# Plan: Vincular código de grupo de bitácora a grupos existentes

## Objetivo
En `lib/views/bitacoras/widgets/add_bitacora_stepper.dart` y su formulario paso 1 (`bitacora_step_1_form.dart`), sustituir la entrada libre de grupo por un selector/listado enlazado a grupos existentes en la base de datos.

## Alcance
- Afecta solo la creación/configuración de bitácoras.
- No implica nuevos servicios, solo reutilizar controller/providers de grupos existentes.

## Cambios propuestos
1. Proveer los grupos existentes en el contexto del stepper usando `classGroupControllerProvider`.
2. Reemplazar el `TextFormField` de grupo por un `DropdownButtonFormField` o `Autocomplete` con:
   - lista cargada desde grupos existentes,
   - preselección opcional del código actual si coincide,
   - guardado en `grupoCtrl` como texto del código elegido.
3. Guard: antes de generar vista previa (`_generateCalendarPreview`) y antes de guardar (`_saveBitacora`), validar que el grupo seleccionado exista en la lista cargada; si no existe, mostrar cuadro de diálogo de advertencia y bloquear avance.
4. Mantener fallback controlado solo si puedes confirmar código por defecto alterno; por defecto, no permitir continuar sin grupo válido.

## Entregables
- `plan.md` listo para ejecutar.
- Confirmación de si prefieres:
  - A) Dropdown de grupos existentes
  - B) Autocomplete (permite escritura pero valida pertenencia)
  - C) Ambos, priorizando dropdown
