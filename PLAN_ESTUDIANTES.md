# Plan Completo de Gestión de Estudiantes - Aula Nova

## Estado Actual ✅
Se han implementado los siguientes componentes:

### 1. **Base de Datos** ✅
- ✅ Tabla `Students` definida en `lib/database/tables.dart`
- ✅ Enum `StudentStatus` (activo, inactivo, graduado)
- ✅ DAO `StudentDao` en `lib/database/daos.dart`
- ✅ Registro en `AppDatabase` (@DriftDatabase)
- ✅ Migración v5 configurada

### 2. **Modelos** ✅
- ✅ Archivo `lib/models/student.dart` con extensiones helper
- ✅ Exportado en `lib/models/app_models.dart`
- ✅ `DatabaseProvider.studentDao` disponible

### 3. **Controladores** ✅
- ✅ `StudentController` en `lib/controllers/student_controller.dart`
- ✅ Métodos: CRUD completo + búsqueda
- ✅ Validaciones: existencia de código único

### 4. **Vistas** ✅
- ✅ `StudentsScreen` pantalla principal
- ✅ `AddStudentDialog` crear estudiante
- ✅ `EditStudentDialog` editar estudiante
- ✅ `StudentCard` tarjeta de visualización
- ✅ Búsqueda y filtrado integrado

### 5. **Navegación** ✅
- ✅ Integrado en `AppLayout` (índice 4)
- ✅ Accesible desde menú secundario
- ✅ Botón FAB en dashboard

---

## Problema Pendiente ⚠️
**Generación de código Drift incompleta**

El generador de Drift (build_runner) no está creando:
- `class Student` en `app_database.g.dart`
- `class StudentsCompanion` 
- Mixin `_$StudentDaoMixin` en `daos.g.dart`
- Propiedad `students` en AppDatabase

### Causa probable
Error de análisis en la tabla `Students` que impide la generación completa.

### Solución
**Opción 1:** Ejecutar build_runner con debug completo:
```bash
dart run build_runner build -v
```

**Opción 2:** Limpiar caché de Flutter y reintentar:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

**Opción 3:** Revertir y re-agregar la tabla paso a paso:
1. Remover `Students` de `app_database.dart` (tablas y daos)
2. Ejecutar `flutter pub run build_runner build`
3. Re-agregar `Students` después de confirmar que funciona

---

## Uso Esperado (Una vez resuelto Drift)

### Crear estudiante
```dart
final controller = StudentController();
await controller.addStudent(
  codigo: '001',
  nombres: 'Juan',
  apellidos: 'Pérez',
  carrera: 'Ingeniería',
);
```

### Listar estudiantes
```dart
final students = await controller.getAllStudents();
final stream = controller.watchAllStudents(); // Para UI reactiva
```

### Buscar
```dart
final results = await controller.searchStudents('Juan');
```

### Editar/Eliminar
```dart
await controller.updateStudent(modifiedStudent);
await controller.deleteStudent(student);
```

---

## Arquitectura Implementada

```
models/
├── student.dart (data class + helpers)
└── app_models.dart (exports)

database/
├── tables.dart (Students table definition)
├── daos.dart (StudentDao)
└── app_database.dart (registration)

controllers/
└── student_controller.dart (business logic)

views/
└── students/
    ├── students_screen.dart (main UI)
    └── widgets/
        ├── add_student_dialog.dart
        ├── edit_student_dialog.dart
        └── student_card.dart
```

**Patrón:** Idéntico a `Careers` y `Modules` (probado y funcionando) ✅

---

## Próximos Pasos (Después de resolver Drift)

1. **Testing:** Ejecutar desde app y verificar CRUD
2. **Relaciones:** Vincular estudiantes con:
   - Módulos/Carreras (para asignaciones)
   - Bitácoras (para asistencia)
3. **Reportes:** Exportar lista de estudiantes a Excel
4. **Validaciones:** Validar formato de email, teléfono, código único

---

## Comandos Útiles

```bash
# Limpiar y regenerar todo
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build

# Con verbose para debug
dart run build_runner build -v

# Desde VS Code
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**Última actualización:** 31 de mayo de 2026
**Estado:** 90% completado (pendiente generación Drift)
