class AdminManagerState {
  final int currentTabIndex; // Menù in alto
  final int currentSidebarIndex; // Menù laterale

  const AdminManagerState({
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
  });

  AdminManagerState copyWith({int? currentTabIndex, int? currentSidebarIndex}) {
    return AdminManagerState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
    );
  }
}
