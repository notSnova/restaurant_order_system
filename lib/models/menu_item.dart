class MenuItem {
  final String imageUrl;
  final String label;

  MenuItem({required this.imageUrl, required this.label});
}

final List<MenuItem> menuItems = [
  MenuItem(imageUrl: "https://placehold.co/176x223", label: "Nasi Lemak"),
  MenuItem(imageUrl: "https://placehold.co/176x223", label: "Bihun Goreng"),
  MenuItem(imageUrl: "https://placehold.co/176x223", label: "Char Kway Teow"),
  MenuItem(imageUrl: "https://placehold.co/176x223", label: "Ayam Goreng"),
];
