# Lógica de Estado de Estudiantes al Eliminar/Finalizar Bitácora

## Descripción

Cuando el usuario elimina una bitácora o cuando esta finaliza su calendario de actividades, los estudiantes **activos** vinculados al grupo de clase de esa bitácora deben cambiar de estado automáticamente según estas reglas:

| Evento | Condición | Nuevo estado del estudiante activo |
|---|---|---|
| Eliminar bitácora | El calendario NO había finalizado | `suspendido` |
| Finalizar módulo (todas las sesiones impartidas) | El calendario SÍ finalizó | `finalizado` |
| Estudiante dado de baja dentro del período del calendario | (ya era `desertado`) | sin cambio → permanece `desertado` |

> Solo los estudiantes con estado `activo` son afectados.

---

## Open Questions

> [!IMPORTANT]
> **¿Cómo se determina "dado dentro del marco del calendario"?**
> El enunciado dice: *"si fue dado dentro del marco del calendario de la bitácora, permanezca como desertado"*. Interpreto que los estudiantes que **ya** tienen estado `desertado` no se tocan en ningún caso. ¿Es correcto?

> [!NOTE]
> El `StudentStatus` actual es `{activo, inactivo, graduado}`. Se deben agregar `suspendido`, `finalizado` y `desertado`. Esto requiere una **migración de base de datos** (nueva schema version).

---

## Proposed Changes

### 1. `tables.dart` — Extender `StudentStatus`

#### [MODIFY] [tables.dart](file:///c:/Users/Uriel/Desktop/proyecto%20Docente%20innovador/aula_nova/lib/database/tables.dart)

Cambiar:
```dart
enum StudentStatus { activo, inactivo, graduado }
```
Por:
```dart
enum StudentStatus { activo, inactivo, graduado, suspendido, finalizado, desertado }
```

Los índices existentes se preservan (`activo=0, inactivo=1, graduado=2`), y los nuevos se agregan al final.

---

### 2. `app_database.dart` — Migración a schema version 6

#### [MODIFY] [app_database.dart](file:///c:/Users/Uriel/Desktop/proyecto%20Docente%20innovador/aula_nova/lib/database/app_database.dart)

- Incrementar `schemaVersion` de `5` a `6`.
- La migración v5→v6 no requiere DDL porque el enum se almacena como `INTEGER` y los nuevos valores son solo índices adicionales (3, 4, 5). No hay columnas nuevas.

---

### 3. `daos.dart` — Lógica de transición de estado en `BitacoraDao`

#### [MODIFY] [daos.dart](file:///c:/Users/Uriel/Desktop/proyecto%20Docente%20innovador/aula_nova/lib/database/daos.dart)

Agregar método `updateActiveStudentsForGroup` en `BitacoraDao`:

```dart
/// Cambia el estado de estudiantes ACTIVOS del grupo a [newStatus].
/// Los estudiantes con estado diferente a `activo` no se modifican.
Future<void> updateActiveStudentsForGroup(
  String grupo,
  StudentStatus newStatus,
) async {
  await (db.update(db.students)
    ..where((s) =>
        s.grupo.equals(grupo) &
        s.estado.equals(StudentStatus.activo.index)))
    .write(StudentsCompanion(estado: Value(newStatus)));
}
```

Modificar `deleteBitacora` para aplicar la lógica:

```dart
Future<void> deleteBitacora(int idBitacora) async {
  // 1. Obtener la bitácora
  final bitacora = await (select(bitacoras)..where((t) => t.id.equals(idBitacora))).getSingleOrNull();

  if (bitacora != null && bitacora.codigoGrupo != null && bitacora.codigoGrupo!.isNotEmpty) {
    // 2. Verificar si el calendario finalizó
    final sessions = await getCalendarioForBitacora(idBitacora);
    final allCompleted = sessions.isNotEmpty && sessions.every((s) => s.estadoImpartido);
    
    // 3. Solo afecta a estudiantes activos
    final newStatus = allCompleted ? StudentStatus.finalizado : StudentStatus.suspendido;
    await updateActiveStudentsForGroup(bitacora.codigoGrupo!, newStatus);
  }
  
  // 4. Eliminar calendario y bitácora
  await deleteCalendarioForBitacora(idBitacora);
  await (delete(bitacoras)..where((t) => t.id.equals(idBitacora))).go();
}
```

También modificar `autoCompletePastSessions` para que al finalizar la bitácora actualice a los estudiantes activos a `finalizado`.

---

### 4. `bitacora_delete_dialog.dart` — Advertencia en UI

#### [MODIFY] [bitacora_delete_dialog.dart](file:///c:/Users/Uriel/Desktop/proyecto%20Docente%20innovador/aula_nova/lib/views/bitacoras/widgets/bitacora_delete_dialog.dart)

Actualizar el texto del diálogo para informar al usuario que los estudiantes activos del grupo cambiarán a "Suspendido":

> "Esta acción eliminará la bitácora y todas sus sesiones. Los estudiantes **activos** del grupo quedarán en estado **Suspendido**. Esta acción no se puede deshacer."

---

### 5. Regenerar código generado por Drift

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Verification Plan

### Automated
- `flutter analyze` sin errores.
- `flutter pub run build_runner build` exitoso.

### Manual
1. Crear una bitácora con un grupo que tenga estudiantes activos.
2. **Caso A**: Eliminar la bitácora antes de que finalice el calendario → verificar que los estudiantes activos del grupo pasen a `suspendido`.
3. **Caso B**: Completar todas las sesiones (autocompletar) → verificar que los estudiantes activos pasen a `finalizado`.
4. **Caso C**: Estudiante con estado `desertado` → no debe cambiar en ningún caso.
