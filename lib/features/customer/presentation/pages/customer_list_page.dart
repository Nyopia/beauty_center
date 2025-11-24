// lib/features/customer/presentation/pages/customer_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/customer.dart';
import '../bloc/customer_bloc.dart';
import 'add_edit_customer_page.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomerBloc>()..add(LoadCustomersEvent()),
      child: Scaffold(
        // AppBar yok çünkü HomePage'in kendi AppBar'ı var, body içinde göstereceğiz.
        // Veya HomePage tasarımına göre buraya da koyabilirsin. Şimdilik koymayalım,
        // Ekleme butonunu FloatingActionButton olarak yapalım.
        floatingActionButton: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _navigateToForm(context, null);
              },
            );
          },
        ),
        body: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('İşlem Başarılı'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<CustomerBloc>().add(LoadCustomersEvent());
            } else if (state is CustomerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerLoaded) {
                if (state.customers.isEmpty) {
                  return const Center(child: Text('Henüz müşteri eklenmemiş.'));
                }
                return ListView.builder(
                  itemCount: state.customers.length,
                  itemBuilder: (context, index) {
                    final customer = state.customers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(customer.name[0].toUpperCase()),
                        ),
                        title: Text(customer.name),
                        subtitle: Text(customer.phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _navigateToForm(context, customer),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _showDeleteDialog(context, customer),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text('Müşteriler yükleniyor...'));
            },
          ),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, Customer? customer) {
    final bloc = context.read<CustomerBloc>();
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: AddEditCustomerPage(customer: customer),
            ),
          ),
        )
        .then((value) {
          if (value == true) {
            bloc.add(LoadCustomersEvent());
          }
        });
  }

  void _showDeleteDialog(BuildContext context, Customer customer) {
    final bloc = context.read<CustomerBloc>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Müşteriyi Sil'),
        content: Text('${customer.name} silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              bloc.add(DeleteCustomerEvent(customer.id));
              Navigator.pop(ctx);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
