// Rappresenta una singola voce del menu laterale (SideMenu).
// Separare questo "dato" dal widget permette di generare le voci
// dinamicamente in base al tab selezionato, invece di scriverle a mano
// dentro SideMenu.

class SidebarItemData {
  final String title;
  final String iconPath;

  const SidebarItemData({required this.title, required this.iconPath});
}
