# Plan de Refactorización - Aula Nova

## Estado base
- `flutter analyze`: 1 issue informativo (`use_build_context_synchronously`), sin errores.
- Foco: deuda técnica con impacto en rendimiento, robustez y mantenibilidad.

---

## Fase 1 — Estabilidad y rendimiento (Alta prioridad)

### 1.1 Evitar consulta `LIKE` + filtrado en memoria para asistencia
- **Cambio**: agregar método `getActiveStudentsByGroup(String groupCode)` en `StudentDao` y exponerlo por `IStudentRepository` / `StudentRepository`.
- **Uso**: `AttendanceController.getAttendanceListForSession` deja de llamar a `searchStudents(groupCode)`.
- **Riesgo**: Medio. Requiere tocar interfaz `IStudentRepository` y sus implementaciones, pero el flujo de asistencia quedará mucho más rápido con grupos grandes.

### 1.2 Eliminar N+1 en borrado de módulo
- **Cambio**: en `ModuleController.updateModuleWithDetails` y `deleteModuleWithDetails`, reemplazar el bucle que borra actividades por unidad por un borrado masivo condicionado al módulo, usando IDs/`codUnit` operando en batch o consulta directa por `idModule`.
- **Riesgo**: Medio. Hay que preservar atomicidad con transacciones Drift; se puede usar `batch` o una query parametrizada nueva en DAO.

### 1.3 Hacer no bloqueante el arranque de BD
- **Cambio**: mover `autoCompletePastSessions` y `_finalizeStudentsForCompletedBitacoras` fuera de `beforeOpen` o ejecutarlos de forma perezosa en background.
- **Riesgo**: Bajo. Evita latencia en apertura de la app cuando hay decenas de bitácoras históricas.

---

## Fase 2 — Calidad y mantenibilidad (Media prioridad)

### 2.1 Reemplazar helper oculto en `excel_extractor_service.dart`
- **Cambio**: convertir `_parseNumeric` en método estático explícito de una clase utilitaria o en top-level documentado, en vez de dejarlo “sueltos” entre parsers.
- **Riesgo**: Bajo. Solo reorganización y naming.

### 2.2 Quitar `debugPrint` en paths sensibles
- **Cambio**: reemplazar `debugPrint` por un logger condicionado a `kDebugMode` o eliminar trazas que incluyen rutas/stack en producción (`module_excel_handler.dart`, controladores varios).
- **Riesgo**: Bajo.

### 2.3 Estandarizar validaciones de Excel
- **Cambio**: centralizar reglas de formato (celdas obligatorias, tipo de dato) en `ExcelTemplateValidator` y propagarlas a `UnitsParser` / `ActivitiesParser`.
- **Riesgo**: Bajo. Mejora retrocompatibilidad con plantillas corruptas.

### 2.4 Limpiar constantes de color “duplicadas”
- **Cambio**: definir alias o extensiones en `AppTheme`/`ShiftColors` para eliminar colores hardcodeados repetidos en vistas ( `Color(0xFFF8FAFC)`, etc.) y usar referencias semánticas.
- **Riesgo**: Bajo.

---

## Fase 3 — Robustez de datos (Media prioridad)

### 3.1 Normalizar relación grupos → carreras por ID
- **Cambio**: migrar `ClassGroups.carrera` a entero con FK a `Careers.id` en lugar de texto por nombre.
- **Riesgo**: Alto. Requiere migración Drift + actualización de queries/repos + controllers. Planificar migración v11.

### 3.2 Agregar índices en tablas consultadas por sesión
- **Cambio**: incluir índices compuestos en `Attendances(idSession, idStudent)` y `CalendarioBitacoras(fechaProgramada, estadoImpartido)` en DAO / migración.
- **Riesgo**: Bajo. Gana rendimiento en listados de asistencia y calendario.

### 3.3 Unificar helpers de path y eliminar path traversal residual
- **Cambio**: dejar una sola utilería `safeExcelPath` en `services/` y usarla en vista y plantilla. Revisar `module_excel_handler.dart` para que no siga dependiendo de rutas raw.
- **Riesgo**: Bajo.

---

## Fase 4 — Pruebas y verificación

### 4.1 Añadir tests unitarios a servicios críticos
- Dosificación: casos borde (sin días de clase, feriados consecutivos, actividades con horas 0).
- Excel extractor: plantilla inválida, campos vacíos, valores no numéricos.
- **Riesgo**: Medio. Aporta seguridad para refactors siguientes.

### 4.2 Añadir test de migración Drift
- Probar flujo de `schemaVersion` actual a nueva con tablas nuevas (estudiantes, bitácoras, asistencia).
- **Riesgo**: Bajo.

---

## Fase 5 — Limpieza final y release readiness

### 5.1 Remover código muerto confirmado
- Variables/expresiones null-aware innecesarias en dashboards y vistas.
- **Riesgo**: Bajo.

### 5.2 Documentar convenciones del proyecto
- Estructura de carpetas, naming, reglas de commits, comandos útiles.
- **Riesgo**: Bajo.

---

## Orden sugerido de implementación
1. `1.1` estabilidad inmediata en asistencia.
2. `1.2` rendimiento borrado en módulos.
3. `1.3` UX de arranque.
4. `2.1` a `2.4` calidad sin riesgo.
5. `3.1` a `3.3` mejoras estructurales.
6. `4.1`, `4.2` y `5.x` limpieza final.
