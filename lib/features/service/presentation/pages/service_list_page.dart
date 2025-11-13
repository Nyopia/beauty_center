import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/service.dart';
import '../bloc/service_bloc.dart';
import 'add_edit_service_page.dart';

class ServiceListPage extends StatelessWidget {
  const ServiceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Bu sayfa için yeni bir ServiceBloc örneği oluşturuyoruz.
    // Sayfa açılır açılmaz hizmetleri yüklemesi için LoadServices event'ini gönderiyoruz.
    return BlocProvider(
      create: (context) => sl<ServiceBloc>()..add(LoadServices()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hizmet Yönetimi'),
          actions: [
            // Yeni Hizmet Ekleme Butonu
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                // state'i build context'in bir parçası olarak yeniden tanımlıyoruz.
                // Bu, onPressed içinde BlocProvider.of<ServiceBloc>(context) yazmaktan kurtarır.
                final serviceBloc = context.read<ServiceBloc>();
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // "Yeni Ekleme" modunda sayfayı açmak için service: null gönderiyoruz.
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value:
                                  serviceBloc, // Mevcut BLoC'u yeni sayfaya paslıyoruz.
                              child: const AddEditServicePage(),
                            ),
                          ),
                        )
                        .then((value) {
                          // AddEditServicePage'den geri dönüldüğünde (pop) listeyi yenilemek için
                          // tekrar LoadServices event'i gönderiyoruz.
                          if (value == true) {
                            // Sadece bir değişiklik yapıldıysa yenile
                            serviceBloc.add(LoadServices());
                          }
                        });
                  },
                );
              },
            ),
          ],
        ),
        body: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state) {
            if (state is ServiceSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('İşlem başarıyla tamamlandı!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Bir işlem (ekleme, silme, güncelleme) başarılı olduğunda
              // listeyi otomatik olarak yeniliyoruz.
              context.read<ServiceBloc>().add(LoadServices());
            } else if (state is ServiceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          // BlocBuilder, state'e göre UI'ı yeniden çizer.
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // ServiceLoaded state'i geldiğinde listeyi göster.
              // Diğer state'ler (örn: ServiceSuccess) UI'da bir liste göstermez.
              if (state is ServiceLoaded) {
                // Eğer hiç hizmet yoksa, kullanıcıya bilgi ver.
                if (state.services.isEmpty) {
                  return const Center(
                    child: Text('Henüz hiç hizmet eklenmemiş.'),
                  );
                }
                return ListView.builder(
                  itemCount: state.services.length,
                  itemBuilder: (context, index) {
                    final service = state.services[index];
                    final serviceBloc = context.read<ServiceBloc>();
                    return ListTile(
                      title: Text(service.name),
                      subtitle: Text(
                        '${service.price} TL - ${service.durationInMinutes} dk',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Düzenleme Butonu
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: serviceBloc,
                                        // "Düzenleme" modu için mevcut hizmeti gönderiyoruz.
                                        child: AddEditServicePage(
                                          service: service,
                                        ),
                                      ),
                                    ),
                                  )
                                  .then((value) {
                                    // Geri dönüldüğünde listeyi yenile
                                    if (value == true) {
                                      serviceBloc.add(LoadServices());
                                    }
                                  });
                            },
                          ),
                          // Silme Butonu
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                _showDeleteDialog(context, service),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              // Başlangıç durumu veya beklenmedik bir durum için.
              return const Center(
                child: Text('Hizmetleri yüklemek için bekleyin...'),
              );
            },
          ),
        ),
      ),
    );
  }

  // Silme onayı için bir dialog gösteren yardımcı metod.
  void _showDeleteDialog(BuildContext context, Service service) {
    final serviceBloc = context.read<ServiceBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hizmeti Sil'),
        content: Text(
          '"${service.name}" adlı hizmeti silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              // Silme event'ini BLoC'a gönder.
              serviceBloc.add(DeleteServiceEvent(service.id));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
