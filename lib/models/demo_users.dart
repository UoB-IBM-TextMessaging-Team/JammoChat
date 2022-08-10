import 'package:flutter/material.dart';

const users = [
  userGordon,
  userSalvatore,
  userSacha,
  userDeven,
  userSahil,
  userReuben,
  userNash,
];

const userGordon = DemoUser(
  id: 'gordon',
  name: 'Gordon Hayes',
  image: 'assets/images/user0.png',
);

const userSalvatore = DemoUser(
  id: 'salvatore',
  name: 'Salvatore Giordano',
  image: 'assets/images/user2.png',
);

const userSacha = DemoUser(
  id: 'sacha',
  name: 'Sacha Arbonel',
  image: 'assets/images/user3.png',
);

const userDeven = DemoUser(
  id: 'deven',
  name: 'Deven Joshi',
  image: 'assets/images/user4.png',
);

const userSahil = DemoUser(
  id: 'sahil',
  name: 'Sahil Kumar',
  image: 'assets/images/user5.png',
);

const userReuben = DemoUser(
  id: 'reuben',
  name: 'Reuben Turner',
  image: 'assets/images/user6.png',
);

const userNash = DemoUser(
  id: 'nash',
  name: 'Nash Ramdial',
  image: 'assets/images/user0.png',
);

@immutable
class DemoUser {
  final String id;
  final String name;
  final String image;

  const DemoUser({
    required this.id,
    required this.name,
    required this.image,
  });
}
