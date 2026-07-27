// Rappresenta una singola voce del menu laterale (SideMenu).
// Separare questo "dato" dal widget permette di generare le voci
// dinamicamente in base al tab selezionato, invece di scriverle a mano
// dentro SideMenu.

class SidebarItemData {
  final int id;
  final String title;
  final String iconPath;
  final List<SidebarItemData>? subItems;

  const SidebarItemData({
    required this.id,
    required this.title,
    required this.iconPath,
    this.subItems,
  });
}
