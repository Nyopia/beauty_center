import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service.dart';
import '../bloc/service_bloc.dart';

class AddEditServicePage extends StatefulWidget {
  // Eğer bu sayfaya bir service nesnesi gönderilirse, "Düzenleme" modunda açılır.
  // Gönderilmezse (null ise), "Yeni Ekleme" modunda açılır.
  final Service? service;

  const AddEditServicePage({super.key, this.service});

  @override
  State<AddEditServicePage> createState() => _AddEditServicePageState();
}

class _AddEditServicePageState extends State<AddEditServicePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    // Controller'ları, düzenleme modundaysak mevcut verilerle dolduruyoruz.
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(
      text: widget.service?.price.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.durationInMinutes.toString() ?? '',
    );
  }

  @override
  void dispose() {
    // Sayfa kapandığında controller'ları temizle.
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveService() {
    // Formun geçerli olup olmadığını kontrol et.
    if (_formKey.currentState!.validate()) {
      // Formdan verileri al.
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final duration = int.parse(_durationController.text);

      // Yeni bir Service nesnesi oluştur.
      final service = Service(
        id:
            widget.service?.id ??
            '', // Düzenleme modundaysak mevcut ID'yi kullan.
        name: name,
        price: price,
        durationInMinutes: duration,
      );

      if (widget.service == null) {
        // Ekleme modu
        context.read<ServiceBloc>().add(AddServiceEvent(service));
      } else {
        // Düzenleme modu
        context.read<ServiceBloc>().add(UpdateServiceEvent(service));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service == null ? 'Yeni Hizmet Ekle' : 'Hizmeti Düzenle',
        ),
      ),
      body: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is ServiceSuccess) {
            // İşlem başarılıysa bir önceki sayfaya dön.
            Navigator.of(context).pop();
          } else if (state is ServiceError) {
            // Hata varsa snackbar göster.
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
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Hizmet Adı'),
                  validator: (value) =>
                      value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
                  keyboardType: TextInputType.number,
                  // TODO: Harf girmeyi engelle
                  validator: (value) =>
                      value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Süre (Dakika)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Bu alan boş bırakılamaz' : null,
                ),
                const SizedBox(height: 20),
                BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    if (state is ServiceLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _saveService,
                      child: Text(
                        widget.service == null ? 'Kaydet' : 'Güncelle',
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
