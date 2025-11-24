// lib/features/customer/presentation/pages/add_edit_customer_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer.dart';
import '../bloc/customer_bloc.dart';

class AddEditCustomerPage extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerPage({super.key, this.customer});

  @override
  State<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends State<AddEditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(
      text: widget.customer?.phoneNumber ?? '',
    );
    _noteController = TextEditingController(text: widget.customer?.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        id: widget.customer?.id ?? '',
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        note: _noteController.text.trim(),
      );

      if (widget.customer == null) {
        context.read<CustomerBloc>().add(AddCustomerEvent(customer));
      } else {
        context.read<CustomerBloc>().add(UpdateCustomerEvent(customer));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer == null ? 'Yeni Müşteri' : 'Müşteriyi Düzenle',
        ),
      ),
      body: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerSuccess) {
            Navigator.of(context).pop(true); // true: Liste yenilensin mi? Evet.
          } else if (state is CustomerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              // Column yerine ListView kullandık, klavye açılınca taşma olmasın diye
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'İsim boş olamaz' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefon Numarası',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Telefon boş olamaz' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Müşteri Notu (Opsiyonel)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3, // Çok satırlı alan
                ),
                const SizedBox(height: 24),
                BlocBuilder<CustomerBloc, CustomerState>(
                  builder: (context, state) {
                    if (state is CustomerLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _saveCustomer,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        widget.customer == null ? 'Kaydet' : 'Güncelle',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
