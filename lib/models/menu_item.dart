class MenuItem {
  final String imageUrl;
  final String label;
  final double price;
  final String category;

  const MenuItem({
    required this.imageUrl,
    required this.label,
    required this.price,
    required this.category,
  });
}

const List<MenuItem> seedMenuItems = [
  MenuItem(
    imageUrl: "assets/menus/nasi_lemak.png",
    label: "Nasi Lemak",
    price: 3.00,
    category: "Food",
  ),
  MenuItem(
    imageUrl: "assets/menus/bihun_goreng.png",
    label: "Bihun Goreng",
    price: 4.50,
    category: "Food",
  ),
  MenuItem(
    imageUrl: "assets/menus/kway_teow_goreng.png",
    label: "Kway Teow Goreng",
    price: 5.00,
    category: "Food",
  ),
  MenuItem(
    imageUrl: "assets/menus/maggi_goreng.png",
    label: "Maggi Goreng",
    price: 4.50,
    category: "Food",
  ),
  MenuItem(
    imageUrl: "assets/menus/kopi_ais.png",
    label: "Kopi Ais",
    price: 2.00,
    category: "Drinks",
  ),
  MenuItem(
    imageUrl: "assets/menus/milo_ais.png",
    label: "Milo Ais",
    price: 2.50,
    category: "Drinks",
  ),
  MenuItem(
    imageUrl: "assets/menus/nescafe_ais.png",
    label: "Nescafe Ais",
    price: 2.50,
    category: "Drinks",
  ),
  MenuItem(
    imageUrl: "assets/menus/teh_tarik_ais.png",
    label: "Teh Tarik Ais",
    price: 2.00,
    category: "Drinks",
  ),
  MenuItem(
    imageUrl: "assets/menus/barli_ais.png",
    label: "Barli Ais",
    price: 3.50,
    category: "Drinks",
  ),
  MenuItem(
    imageUrl: "assets/menus/sup_ayam.png",
    label: "Sup Ayam",
    price: 5.00,
    category: "Soups",
  ),
  MenuItem(
    imageUrl: "assets/menus/sup_daging.png",
    label: "Sup Daging",
    price: 6.00,
    category: "Soups",
  ),
  MenuItem(
    imageUrl: "assets/menus/sup_ekor.png",
    label: "Sup Ekor",
    price: 5.50,
    category: "Soups",
  ),
  MenuItem(
    imageUrl: "assets/menus/sup_kambing.png",
    label: "Sup Kambing",
    price: 7.00,
    category: "Soups",
  ),
  MenuItem(
    imageUrl: "assets/menus/tomyam_ayam.png",
    label: "Tomyam Ayam",
    price: 6.00,
    category: "Soups",
  ),
  MenuItem(
    imageUrl: "assets/menus/ais_batu_campur.png",
    label: "ABC",
    price: 4.00,
    category: "Desserts",
  ),
  MenuItem(
    imageUrl: "assets/menus/banana_split.png",
    label: "Banana Split",
    price: 5.00,
    category: "Desserts",
  ),
  MenuItem(
    imageUrl: "assets/menus/cendol.png",
    label: "Cendol",
    price: 3.00,
    category: "Desserts",
  ),
];
