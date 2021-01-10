class Product {
  final int id, price;
  final String title, description, image;

  Product({this.id, this.price, this.title, this.description, this.image});
}

// list of products
// for our demo
List<Product> products = [
  Product(
    id: 1,
    price: 56,
    title: "Building 1",
    image: "assets/images/Item_1.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
  Product(
    id: 4,
    price: 68,
    title: "Building 2",
    image: "assets/images/Item_2.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
  Product(
    id: 9,
    price: 39,
    title: "Building 3",
    image: "assets/images/Item_3.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
  Product(
    id: 10,
    price: 39,
    title: "Building 4",
    image: "assets/images/Item_4.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
  Product(
    id: 11,
    price: 39,
    title: "Building 5",
    image: "assets/images/build5.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
  Product(
    id: 12,
    price: 39,
    title: "Building 6",
    image: "assets/images/Item_3.png",
    description:
        "3 bedrooms, 1 balcony, 2 parking spaces, Open Kitchen",
  ),
];
