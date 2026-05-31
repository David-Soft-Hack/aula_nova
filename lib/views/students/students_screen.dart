import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/theme/app_theme.dart';
import '../../controllers/student_controller.dart';
import '../../database/app_database.dart';
import '../../models/student.dart';
import 'widgets/add_student_dialog.dart';
import 'widgets/edit_student_dialog.dart';
import 'widgets/student_card.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final StudentController _controller = StudentController();
  String _searchQuery = '';

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddStudentDialog(controller: _controller),
    );
  }

  void _showEditStudentDialog(Student student) {
    showDialog(
      context: context,
      builder: (context) => EditStudentDialog(controller: _controller, student: student),
    );
  }

  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar estudiante'),
        content: const Text('¿Estás seguro de eliminar este estudiante?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await _controller.deleteStudent(student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildAddButton(),
          const SizedBox(height: 16),
          Expanded(child: _buildStudentList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestión de Estudiantes',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Outfit',
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crea, edita y administra tu lista de estudiantes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, código o carrera',
          prefixIcon: const Icon(LucideIcons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _showAddStudentDialog,
          icon: const Icon(LucideIcons.plus, size: 20),
          label: const Text('Agregar Estudiante'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.academic600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return StreamBuilder<List<Student>>(
      stream: _controller.watchAllStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data ?? [];
        final filtered = _searchQuery.trim().isEmpty
            ? students
            : students.where((student) {
                final query = _searchQuery.toLowerCase();
                return student.fullName.toLowerCase().contains(query) ||
                    student.codigo.toLowerCase().contains(query) ||
                    (student.carrera?.toLowerCase().contains(query) ?? false);
              }).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text('No existen estudiantes registrados aún.', style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final student = filtered[index];
            return StudentCard(
              student: student,
              onEdit: () => _showEditStudentDialog(student),
              onDelete: () => _deleteStudent(student),
            );
          },
        );
      },
    );
  }
}
