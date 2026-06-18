import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _filterScrollController = ScrollController();

  final _aboutKey = GlobalKey();
  final _advantagesKey = GlobalKey();
  final _applicationsKey = GlobalKey();
  final _productsKey = GlobalKey();
  final _contactsKey = GlobalKey();

  String _selectedCategory = 'Все';
  bool _isScrolled = false;
  bool _showBackToTop = false;

  final List<Map<String, dynamic>> _cart = [];
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _currentLang = 'ru';

  static const List<Map<String, dynamic>> _allProducts = [
    {
      'id': '1',
      'name_ru': 'Геотекстиль иглопробивной',
      'name_en': 'Needlepunched Geotextile',
      'category_ru': 'Нетканый',
      'category_en': 'Non-woven',
      'desc_ru': 'Универсальный материал для разделения слоёв грунта, дренажа и фильтрации',
      'desc_en': 'Universal material for soil layer separation, drainage and filtration',
      'image': 'https://images.unsplash.com/photo-1642761724824-cea70f39ee4d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'id': '2',
      'name_ru': 'Геотекстиль тканый',
      'name_en': 'Woven Geotextile',
      'category_ru': 'Тканый',
      'category_en': 'Woven',
      'desc_ru': 'Повышенная прочность на разрыв. Идеален для армирования дорог',
      'desc_en': 'High tensile strength. Ideal for road reinforcement',
      'image': 'https://avatars.mds.yandex.net/i?id=bd53aeddc394bafdaae39b53a0f1fa8be558b824-5240048-images-thumbs&n=13'
    },
    {
      'id': '3',
      'name_ru': 'Геомембрана HDPE',
      'name_en': 'HDPE Geomembrane',
      'category_ru': 'Мембраны',
      'category_en': 'Membranes',
      'desc_ru': 'Надёжная гидроизоляция прудов, полигонов и резервуаров',
      'desc_en': 'Reliable waterproofing for ponds, landfills and reservoirs',
      'image': 'https://image.made-in-china.com/2f0j00aJUbYIGcJlpO/High-Density-Polyethylene-Liner-for-Landfills-and-Water-Pond-Construction.webp'
    },
    {
      'id': '4',
      'name_ru': 'Геосетка дорожная',
      'name_en': 'Road Geogrid',
      'category_ru': 'Геосетка',
      'category_en': 'Geogrid',
      'desc_ru': 'Армирование дорожного полотна и укрепление слабых грунтов',
      'desc_en': 'Reinforcement of roadbed and strengthening of weak soils',
      'image': 'https://avatars.mds.yandex.net/i?id=264961c2e81d16c5127c37c0c282195ef40171bc-5334852-images-thumbs&n=13'
    },
    {
      'id': '5',
      'name_ru': 'Георешётка объёмная',
      'name_en': '3D Geocell',
      'category_ru': 'Геосетка',
      'category_en': 'Geogrid',
      'desc_ru': 'Укрепление откосов и предотвращение эрозии',
      'desc_en': 'Slope stabilization and erosion prevention',
      'image': 'https://avatars.mds.yandex.net/i?id=58e024fb1fbb26f14d3f2328b9caabae36f16f60-4274684-images-thumbs&n=13'
    },
    {
      'id': '6',
      'name_ru': 'Геотекстиль термоскреплённый',
      'name_en': 'Thermally Bonded Geotextile',
      'category_ru': 'Нетканый',
      'category_en': 'Non-woven',
      'desc_ru': 'Улучшенная фильтрация в сложных условиях',
      'desc_en': 'Improved filtration in harsh conditions',
      'image': 'https://avatars.mds.yandex.net/get-mpic/5218438/img_id2112344986611237022.jpeg/orig'
    },
    {
      'id': '7',
      'name_ru': 'Геонет дренажный',
      'name_en': 'Drainage Geonet',
      'category_ru': 'Мембраны',
      'category_en': 'Membranes',
      'desc_ru': 'Эффективный отвод воды в дренажных системах',
      'desc_en': 'Efficient water drainage in drainage systems',
      'image': 'https://image.made-in-china.com/2f0j00FplcZfkWJGrQ/Two-Dimensional-HDPE-Extruded-Geonet-Bi-Planar.webp'
    },
    {
      'id': '8',
      'name_ru': 'Геокомпозит',
      'name_en': 'Geocomposite',
      'category_ru': 'Тканый',
      'category_en': 'Woven',
      'desc_ru': 'Комбинация геотекстиля и геосетки',
      'desc_en': 'Combination of geotextile and geogrid',
      'image': 'https://avatars.mds.yandex.net/i?id=e4b994d57d11586bac40a221a27f134c31c61f26-5391161-images-thumbs&n=13'
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final newIsScrolled = offset > 100;
    final newShowBackToTop = offset > 600;
    if (newIsScrolled != _isScrolled || newShowBackToTop != _showBackToTop) {
      setState(() {
        _isScrolled = newIsScrolled;
        _showBackToTop = newShowBackToTop;
      });
    }
  }

  void _toggleLanguage() {
    setState(() {
      _currentLang = _currentLang == 'ru' ? 'en' : 'ru';
    });
  }

  List<Map<String, dynamic>> get filteredProducts {
    final list = _selectedCategory == 'Все' || _selectedCategory == 'All'
        ? _allProducts
        : _allProducts.where((p) =>
            (p['category_ru'] == _selectedCategory || p['category_en'] == _selectedCategory)
          ).toList();

    return list.map((p) => {
      'id': p['id'],
      'name': _currentLang == 'ru' ? p['name_ru'] : p['name_en'],
      'category': _currentLang == 'ru' ? p['category_ru'] : p['category_en'],
      'desc': _currentLang == 'ru' ? p['desc_ru'] : p['desc_en'],
      'image': p['image'],
    }).toList();
  }

     // ==================== МУЛЬТИЯЗЫЧНЫЕ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ====================

  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _currentLang == 'ru' 
                ? 'Не удалось открыть номер' 
                : 'Could not open phone number',
          ),
        ),
      );
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': _currentLang == 'ru' 
            ? 'Заявка с сайта GeoSib' 
            : 'Request from GeoSib website',
        'body': _currentLang == 'ru'
            ? 'Здравствуйте!\n\nПишу по поводу геоматериалов.\n\nИмя: \nТелефон: \nГород: \nСообщение: \n\nС уважением,'
            : 'Hello!\n\nI am writing regarding geosynthetic materials.\n\nName: \nPhone: \nCity: \nMessage: \n\nBest regards,',
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        await launchUrl(emailUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _currentLang == 'ru'
                  ? 'Не удалось открыть почту. Напишите нам на $email'
                  : 'Could not open email client. Please write to $email',
            ),
            action: SnackBarAction(
              label: _currentLang == 'ru' ? 'Копировать' : 'Copy',
              onPressed: () => _copyToClipboard(email),
            ),
          ),
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLang == 'ru'
              ? 'Почта скопирована: $text'
              : 'Email copied: $text',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _filterScrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openTelegram() async {
    final Uri url = Uri.parse('https://t.me/yourusername'); // ← Замени на реальный
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/79001234567'); // ← Замени на реальный
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    final exists = _cart.any((item) => item['id'] == product['id']);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _currentLang == 'ru' 
                ? 'Товар уже в корзине' 
                : 'Product is already in cart',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _cart.add(product));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentLang == 'ru'
              ? '${product['name']} добавлен в корзину'
              : '${product['name']} added to cart',
        ),
        backgroundColor: const Color(0xFF00B8A9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

      void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentLang == 'ru' ? 'Корзина' : 'Cart',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${_cart.length} ${_currentLang == 'ru' ? 'товаров' : 'items'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  Expanded(
                    child: _cart.isEmpty
                        ? Center(
                            child: Text(
                              _currentLang == 'ru' ? 'Корзина пуста' : 'Cart is empty',
                              style: const TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(item['image'], width: 60, height: 60, fit: BoxFit.cover),
                                  ),
                                  title: Text(item['name']),
                                  subtitle: Text(item['desc'], maxLines: 2, overflow: TextOverflow.ellipsis),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() => _cart.removeAt(index));
                                      Navigator.pop(context);
                                      _showCart();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  if (_cart.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _currentLang == 'ru'
                                    ? 'Заявка успешно отправлена! Мы свяжемся с вами в ближайшее время.'
                                    : 'Request sent successfully! We will contact you soon.',
                              ),
                              backgroundColor: const Color(0xFF00B8A9),
                            ),
                          );
                          setState(() => _cart.clear());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A2540),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        child: Text(
                          _currentLang == 'ru' ? 'Отправить заявку' : 'Send Request',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    final isDialogWide = MediaQuery.of(context).size.width > 800;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        insetPadding: EdgeInsets.all(isDialogWide ? 32 : 16),
        child: Container(
          width: isDialogWide ? 980 : double.infinity,
          constraints: BoxConstraints(maxHeight: isDialogWide ? 680 : MediaQuery.of(context).size.height * 0.9),
          padding: EdgeInsets.all(isDialogWide ? 40 : 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: isDialogWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(product['image'], width: 440, height: 440, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 48),
                          Expanded(child: _buildProductDetailInfo(product, isDialogWide)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(product['image'], width: double.infinity, height: 240, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 24),
                          _buildProductDetailInfo(product, isDialogWide),
                        ],
                      ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailInfo(Map<String, dynamic> product, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product['name'],
          style: TextStyle(fontSize: isWide ? 34 : 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          product['desc'],
          style: TextStyle(fontSize: isWide ? 18 : 15, height: 1.6, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 32),
        Text(
          _currentLang == 'ru' ? 'Характеристики' : 'Specifications',
          style: TextStyle(fontSize: isWide ? 24 : 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _detailRow(_currentLang == 'ru' ? 'Материал' : 'Material', 'Полипропилен / Полиэстер'),
        _detailRow(_currentLang == 'ru' ? 'Ширина рулона' : 'Roll Width', '2–6 метров'),
        _detailRow(_currentLang == 'ru' ? 'Длина рулона' : 'Roll Length', '50–150 метров'),
        _detailRow(_currentLang == 'ru' ? 'Плотность' : 'Density', 'От 100 до 600 г/м²'),
        _detailRow(_currentLang == 'ru' ? 'Срок службы' : 'Service Life', 'До 50 лет'),
        _detailRow(_currentLang == 'ru' ? 'Производство' : 'Production', 'Россия / Китай'),
        _detailRow(_currentLang == 'ru' ? 'Морозостойкость' : 'Frost Resistance', 'До -60°C'),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _addToCart(product);
                },
                icon: const Icon(Icons.shopping_cart),
                label: Text(_currentLang == 'ru' ? 'В корзину' : 'Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B8A9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _openWhatsApp();
                },
                icon: const Icon(Icons.chat),
                label: Text(_currentLang == 'ru' ? 'Спросить цену' : 'Ask for Price'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 1100;

    return Scaffold(
      drawer: isWide ? null : _buildDrawer(),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
                           // ==================== ХЕДЕР — УЛУЧШЕННЫЙ (ПРЕМИУМ) ====================
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: _isScrolled ? 4 : 2,
                toolbarHeight: isWide ? 88 : 72,
                automaticallyImplyLeading: false,
                leading: isWide
                    ? null
                    : Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, size: 28),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                title: Row(
                  children: [
                    // Лого
                    GestureDetector(
                      onTap: _scrollToTop,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/logo.png', height: isWide ? 52 : 38),
                          if (isWide) ...[
                            const SizedBox(width: 14),
                            const Text(
                              'GeoSib',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0A2540),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    if (isWide) ...[
                      _buildMenuItem(_currentLang == 'ru' ? 'О нас' : 'About Us', () => _scrollToKey(_aboutKey)),
                      const SizedBox(width: 44),
                      _buildMenuItem(_currentLang == 'ru' ? 'Преимущества' : 'Advantages', () => _scrollToKey(_advantagesKey)),
                      const SizedBox(width: 44),
                      _buildMenuItem(_currentLang == 'ru' ? 'Продукция' : 'Products', () => _scrollToKey(_productsKey)),
                      const SizedBox(width: 44),
                      _buildMenuItem(_currentLang == 'ru' ? 'Контакты' : 'Contacts', () => _scrollToKey(_contactsKey)),
                      const Spacer(),
                    ],

                    // Переключатель языка
                    if (isWide)
                      GestureDetector(
                        onTap: _toggleLanguage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentLang == 'ru' ? '🇷🇺' : '🇬🇧',
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentLang.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0A2540),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(width: isWide ? 24 : 4),

                    PopupMenuButton<String>(
                      tooltip: _currentLang == 'ru' ? 'Отправить' : 'Send',
                      offset: const Offset(0, 50),
                      icon: Icon(Icons.send, size: isWide ? 27 : 22, color: const Color(0xFF0A2540)),
                      onSelected: (value) {
                        if (value == 'tg') _openTelegram();
                        if (value == 'wa') _openWhatsApp();
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'tg',
                          child: Row(children: [const Icon(Icons.telegram, color: Color(0xFF229ED9)), const SizedBox(width: 12), Text(_currentLang == 'ru' ? 'Telegram' : 'Telegram')]),
                        ),
                        PopupMenuItem(
                          value: 'wa',
                          child: Row(children: [const Icon(Icons.chat, color: Color(0xFF25D366)), const SizedBox(width: 12), Text(_currentLang == 'ru' ? 'WhatsApp' : 'WhatsApp')]),
                        ),
                      ],
                    ),

                    SizedBox(width: isWide ? 16 : 4),

                    // Корзина
                    Stack(
                      children: [
                        IconButton(
                          onPressed: _showCart,
                          icon: Icon(Icons.shopping_cart_outlined, size: isWide ? 27 : 22),
                        ),
                        if (_cart.isNotEmpty)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(color: Color(0xFF00B8A9), shape: BoxShape.circle),
                              child: Text('${_cart.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(width: isWide ? 16 : 4),

                    // Кнопка заявки
                    ElevatedButton(
                      onPressed: () => _scrollToKey(_contactsKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2540),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12, vertical: isWide ? 14 : 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                      ),
                      child: Text(
                        _currentLang == 'ru'
                            ? (isWide ? 'Оставить заявку' : 'Заявка')
                            : (isWide ? 'Leave Request' : 'Request'),
                        style: TextStyle(fontSize: isWide ? 14.5 : 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              
              // ==================== HERO — ПРЕМИУМ ДИЗАЙН ====================
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * (isWide ? 1.0 : 0.92),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1591486085897-f433f05e7aed?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.82),
                        ],
                        stops: const [0.0, 0.65, 1.0],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Улучшенный шрифт GeoSib
                          Text(
                            _currentLang == 'ru' ? 'GeoSib' : 'GeoSib',
                            style: TextStyle(
                              fontSize: isWide ? 112 : 82,
                              fontWeight: FontWeight.w900,           // ← сделал максимально жирным
                              color: Colors.white,
                              letterSpacing: isWide ? -6 : -4,        // чуть меньше сжатия
                              height: 0.9,
                              shadows: const [
                                Shadow(
                                  blurRadius: 20,
                                  color: Colors.black26,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 1100.ms).slideY(begin: 0.3),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * (isWide ? 0.72 : 0.85),
                            child: Text(
                              _currentLang == 'ru'
                                  ? 'Геоматериалы, на которых стоит Сибирь'
                                  : 'Geosynthetics on which Siberia stands',
                              style: TextStyle(
                                fontSize: isWide ? 44 : 34,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                          ),

                          const SizedBox(height: 88),

                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 28,
                            runSpacing: 20,
                            children: [
                              ElevatedButton(
                                onPressed: () => _scrollToKey(_productsKey),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00B8A9),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 26),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  elevation: 6,
                                ),
                                child: Text(
                                  _currentLang == 'ru' ? 'Посмотреть каталог' : 'Browse Catalog',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _scrollToKey(_contactsKey),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white, width: 3.5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 26),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                child: Text(
                                  _currentLang == 'ru' ? 'Оставить заявку' : 'Leave Request',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================== СТАТИСТИКА ====================
              SliverToBoxAdapter(
                child: Container(
                  key: _aboutKey,
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                  color: const Color(0xFF0A2540),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 700;
                      final stats = [
                        {'value': '10+', 'label_ru': 'Лет опыта', 'label_en': 'Years Experience', 'icon': Icons.calendar_today},
                        {'value': '500+', 'label_ru': 'Проектов', 'label_en': 'Projects', 'icon': Icons.assignment_turned_in},
                        {'value': '20+', 'label_ru': 'Регионов', 'label_en': 'Regions', 'icon': Icons.map},
                        {'value': '100%', 'label_ru': 'Гарантия качества', 'label_en': 'Quality Guarantee', 'icon': Icons.verified},
                      ];

                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: isNarrow ? 24 : 80,
                        runSpacing: 40,
                        children: stats.asMap().entries.map((entry) {
                          final s = entry.value;
                          return SizedBox(
                            width: isNarrow ? constraints.maxWidth / 2 - 36 : null,
                            child: Column(
                              children: [
                                Icon(s['icon'] as IconData, color: const Color(0xFF00B8A9), size: 36),
                                const SizedBox(height: 14),
                                Text(
                                  s['value'] as String,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentLang == 'ru' ? s['label_ru'] as String : s['label_en'] as String,
                                  style: const TextStyle(fontSize: 17, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),

              // ==================== ПРЕИМУЩЕСТВА ====================
              SliverToBoxAdapter(
                child: Container(
                  key: _advantagesKey,
                  padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 40),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        _currentLang == 'ru' ? 'Почему выбирают GeoSib' : 'Why Choose GeoSib',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A2540),
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        _currentLang == 'ru'
                            ? 'Надёжные решения для сурового сибирского климата'
                            : 'Reliable solutions for the harsh Siberian climate',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 110),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount;
                          double mainAxisExtent;

                          if (constraints.maxWidth > 1400) {
                            crossAxisCount = 4;
                            mainAxisExtent = 380;
                          } else if (constraints.maxWidth > 900) {
                            crossAxisCount = 2;
                            mainAxisExtent = 380;
                          } else {
                            crossAxisCount = 1;
                            mainAxisExtent = 420;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisExtent: mainAxisExtent,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) => _buildFeatureCard(index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

                            // ==================== ПРИМЕНЕНИЕ — ПРЕМИУМ ДИЗАЙН ====================
              SliverToBoxAdapter(
                child: Container(
                  key: _applicationsKey,
                  padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 40),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        _currentLang == 'ru' ? 'Где применяются наши материалы' : 'Where Our Materials Are Used',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A2540),
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        _currentLang == 'ru'
                            ? 'Реальные задачи — проверенные решения'
                            : 'Real challenges — proven solutions',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 110),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount;
                          double mainAxisExtent;

                          if (constraints.maxWidth > 1400) {
                            crossAxisCount = 3;
                            mainAxisExtent = 400;
                          } else if (constraints.maxWidth > 900) {
                            crossAxisCount = 2;
                            mainAxisExtent = 400;
                          } else {
                            crossAxisCount = 1;
                            mainAxisExtent = 420;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisExtent: mainAxisExtent,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) => _buildApplicationCard(index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

                            // ==================== КАТАЛОГ — ПРЕМИУМ ДИЗАЙН ====================
              SliverToBoxAdapter(
                child: Container(
                  key: _productsKey,
                  padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF8F9FA), Colors.white],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _currentLang == 'ru' ? 'Каталог продукции' : 'Product Catalog',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A2540),
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        _currentLang == 'ru'
                            ? 'Выберите материал под ваш проект'
                            : 'Choose the right material for your project',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 70),

                      // ==================== ФИЛЬТРЫ ====================
                     Scrollbar(
                        controller: _filterScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        thickness: 8,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          controller: _filterScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              'Все', 'Тканый', 'Нетканый', 'Мембраны', 'Геосетка'
                            ].map((cat) {
                              final isSelected = _selectedCategory == cat;

                              // Перевод названий фильтров
                              String displayName = cat;
                              if (_currentLang == 'en') {
                                displayName = cat == 'Все' ? 'All' :
                                              cat == 'Тканый' ? 'Woven' :
                                              cat == 'Нетканый' ? 'Non-woven' :
                                              cat == 'Мембраны' ? 'Membranes' : 'Geogrid';
                              }

                              // Увеличенная ширина
                              final baseWidth = cat.length > 7 ? 195.0 : 165.0;
                              final width = isSelected ? baseWidth + 45 : baseWidth;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: SizedBox(
                                  width: width,
                                  child: FilterChip(
                                    label: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (val) => setState(() => _selectedCategory = cat),
                                    backgroundColor: Colors.white,
                                    selectedColor: const Color(0xFF00B8A9),
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF0A2540),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18), // ← увеличил padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    elevation: isSelected ? 4 : 1,
                                    shadowColor: Colors.black.withValues(alpha: 0.1),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 90),

                      // ==================== СЕТКА ТОВАРОВ ====================
                      Center(
                        child: SizedBox(
                          width: 1520,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            cacheExtent: 1000,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              mainAxisExtent: 480,
                              crossAxisSpacing: 36,
                              mainAxisSpacing: 36,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

                            // ==================== КОНТАКТЫ + ФОРМА ЗАЯВКИ — ПРЕМИУМ ДИЗАЙН ====================
              SliverToBoxAdapter(
                child: Container(
                  key: _contactsKey,
                  padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 40),
                  color: const Color(0xFF0A2540),
                  child: Column(
                    children: [
                      Text(
                        _currentLang == 'ru' ? 'Свяжитесь с нами' : 'Contact Us',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        _currentLang == 'ru'
                            ? 'Готовы помочь с подбором материалов для вашего проекта'
                            : 'Ready to help you choose the right materials for your project',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 110),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 1100;
                          return isWide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 5, child: _buildContactInfo()),
                                    const SizedBox(width: 100),
                                    Expanded(flex: 7, child: _buildContactForm()),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _buildContactInfo(),
                                    const SizedBox(height: 100),
                                    _buildContactForm(),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),

                            // ==================== FOOTER — ПРЕМИУМ ДИЗАЙН ====================
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF0A2540),
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 700;

                          return isNarrow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFooterBrand(),
                                    const SizedBox(height: 70),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: _buildFooterNav()),
                                        Expanded(child: _buildFooterContacts()),
                                      ],
                                    ),
                                    const SizedBox(height: 70),
                                    _buildFooterSocial(),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFooterBrand(),
                                    const SizedBox(width: 100),
                                    Expanded(child: _buildFooterNav()),
                                    const SizedBox(width: 80),
                                    Expanded(child: _buildFooterContacts()),
                                    const SizedBox(width: 80),
                                    Expanded(child: _buildFooterSocial()),
                                  ],
                                );
                        },
                      ),

                      const SizedBox(height: 90),
                      const Divider(color: Colors.white24, thickness: 1),
                      const SizedBox(height: 32),

                      Text(
                        _currentLang == 'ru'
                            ? '© 2026 ООО ТД "Сибирь Строй Комплектация" • Все права защищены'
                            : '© 2026 Sibir Stroy Komplektatsiya LLC • All rights reserved',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
                    // Универсальная кнопка "Наверх"
          Positioned(
            left: isWide ? 24 : null,
            right: isWide ? null : 16,
            bottom: isWide ? 24 : 16,
            child: AnimatedOpacity(
              opacity: _showBackToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton(
                mini: !isWide,
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xFF00B8A9),
                elevation: isWide ? 6 : 4,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: isWide ? 28 : 24,
                ),
              ),
            ),
          ),
          ],
        ),
      );
    }

  // Остальные методы (без изменений)
  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0A2540)),
            child: Center(
              child: Text(
                'GeoSib',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: Text(_currentLang == 'ru' ? 'Главная' : 'Home'),
            onTap: () {
              Navigator.pop(context);
              _scrollToTop();
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(_currentLang == 'ru' ? 'О нас' : 'About Us'),
            onTap: () {
              Navigator.pop(context);
              _scrollToKey(_aboutKey);
            },
          ),

          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(_currentLang == 'ru' ? 'Преимущества' : 'Advantages'),
            onTap: () {
              Navigator.pop(context);
              _scrollToKey(_advantagesKey);
            },
          ),

          ListTile(
            leading: const Icon(Icons.layers),
            title: Text(_currentLang == 'ru' ? 'Применение' : 'Applications'),
            onTap: () {
              Navigator.pop(context);
              _scrollToKey(_applicationsKey);
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: Text(_currentLang == 'ru' ? 'Продукция' : 'Products'),
            onTap: () {
              Navigator.pop(context);
              _scrollToKey(_productsKey);
            },
          ),

          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: Text(_currentLang == 'ru' ? 'Контакты' : 'Contacts'),
            onTap: () {
              Navigator.pop(context);
              _scrollToKey(_contactsKey);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(_currentLang == 'ru' ? 'Язык' : 'Language'),
            subtitle: Text(_currentLang == 'ru' ? '🇷🇺 Русский' : '🇬🇧 English'),
            onTap: () {
              _toggleLanguage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(int index) {
    final features = [
      {
        'icon': Icons.ac_unit,
        'title_ru': 'Морозостойкость',
        'title_en': 'Frost Resistance',
        'desc_ru': 'Выдерживают температуры до -60°C без потери свойств',
        'desc_en': 'Withstand temperatures down to -60°C without loss of properties'
      },
      {
        'icon': Icons.security,
        'title_ru': 'Высокая прочность',
        'title_en': 'High Strength',
        'desc_ru': 'Отличное сопротивление разрыву и проколу',
        'desc_en': 'Excellent resistance to tearing and puncturing'
      },
      {
        'icon': Icons.water_drop,
        'title_ru': 'Эффективная фильтрация',
        'title_en': 'Effective Filtration',
        'desc_ru': 'Пропускают воду и задерживают грунт',
        'desc_en': 'Allow water to pass while retaining soil'
      },
      {
        'icon': Icons.timer,
        'title_ru': 'Долговечность',
        'title_en': 'Durability',
        'desc_ru': 'Срок службы более 50 лет',
        'desc_en': 'Service life over 50 years'
      },
    ];

    final f = features[index];

    return Container(
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF00B8A9).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              f['icon'] as IconData,
              size: 72,
              color: const Color(0xFF00B8A9),
            ),
          ),
          const SizedBox(height: 32),

          Text(
            _currentLang == 'ru' ? f['title_ru'] as String : f['title_en'] as String,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0A2540),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          Text(
            _currentLang == 'ru' ? f['desc_ru'] as String : f['desc_en'] as String,
            style: const TextStyle(
              fontSize: 16.8,
              height: 1.55,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              product['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheHeight: 250,
              cacheWidth: 400,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 250,
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      product['desc'],
                      style: const TextStyle(fontSize: 15.2, height: 1.45, color: Color(0xFF64748B)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showProductDetail(product),
                          child: Text(_currentLang == 'ru' ? 'Подробнее' : 'Details'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00B8A9),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_currentLang == 'ru' ? 'В корзину' : 'Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== КОНТАКТНАЯ ИНФОРМАЦИЯ ====================
    Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentLang == 'ru' ? 'Контактная информация' : 'Contact Information',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 50),

        _contactRow(Icons.phone, '+7 (982) 975-90-75', onTap: () => _launchPhone('+79829759075')),
        const SizedBox(height: 32),

        _contactRow(Icons.email, 'td_ssk@bk.ru', onTap: () => _launchEmail('td_ssk@bk.ru')),
        const SizedBox(height: 50),

        Text(
          _currentLang == 'ru' ? 'Адрес:' : 'Address:',
          style: const TextStyle(fontSize: 20, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        const Text(
          'г. Тюмень, ул. Сиреневая, 12',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _contactRow(IconData icon, String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00B8A9), size: 28),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(52),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentLang == 'ru' ? 'Оставить заявку' : 'Submit a Request',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xFF0A2540)),
          ),
          const SizedBox(height: 40),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: _currentLang == 'ru' ? 'Ваше имя' : 'Your Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: _currentLang == 'ru' ? 'Телефон' : 'Phone',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: _currentLang == 'ru' ? 'Сообщение / описание проекта' : 'Message / Project Description',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Icon(Icons.message_outlined),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _currentLang == 'ru'
                          ? 'Заявка успешно отправлена! Мы свяжемся с вами в ближайшее время.'
                          : 'Request sent successfully! We will contact you soon.',
                    ),
                    backgroundColor: const Color(0xFF00B8A9),
                  ),
                );
                _nameController.clear();
                _phoneController.clear();
                _messageController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B8A9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 5,
              ),
              child: Text(
                _currentLang == 'ru' ? 'Отправить заявку' : 'Send Request',
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

   // ==================== КАРТОЧКИ ПРИМЕНЕНИЯ — УЛУЧШЕННЫЙ ДИЗАЙН ====================
  Widget _buildApplicationCard(int index) {
    final applications = [
      {
        'icon': Icons.directions_car,
        'title_ru': 'Дорожное строительство',
        'title_en': 'Road Construction',
        'desc_ru': 'Армирование полотна, разделение слоёв, дренаж',
        'desc_en': 'Roadbed reinforcement, layer separation, drainage',
        'color': const Color(0xFF00B8A9)
      },
      {
        'icon': Icons.factory,
        'title_ru': 'Промышленные площадки',
        'title_en': 'Industrial Sites',
        'desc_ru': 'Укрепление грунта под тяжёлую технику',
        'desc_en': 'Soil strengthening for heavy machinery',
        'color': const Color(0xFF1E88E5)
      },
      {
        'icon': Icons.water,
        'title_ru': 'Гидротехнические сооружения',
        'title_en': 'Hydraulic Structures',
        'desc_ru': 'Геомембраны для прудов, каналов и полигонов',
        'desc_en': 'Geomembranes for ponds, channels and landfills',
        'color': const Color(0xFF0288D1)
      },
      {
        'icon': Icons.landscape,
        'title_ru': 'Ландшафтный дизайн',
        'title_en': 'Landscape Design',
        'desc_ru': 'Стабилизация грунта, укрепление склонов',
        'desc_en': 'Soil stabilization and slope reinforcement',
        'color': const Color(0xFF43A047)
      },
      {
        'icon': Icons.train,
        'title_ru': 'Железнодорожное строительство',
        'title_en': 'Railway Construction',
        'desc_ru': 'Укрепление насыпи и балластного слоя',
        'desc_en': 'Embankment and ballast layer reinforcement',
        'color': const Color(0xFF5E35B1)
      },
      {
        'icon': Icons.home,
        'title_ru': 'Частное строительство',
        'title_en': 'Private Construction',
        'desc_ru': 'Дренаж фундаментов и садовых участков',
        'desc_en': 'Foundation drainage and garden plots',
        'color': const Color(0xFFFB8C00)
      },
    ];

    final app = applications[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: app['color'] as Color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            ),
            child: Center(
              child: Icon(
                app['icon'] as IconData,
                size: 82,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentLang == 'ru' ? app['title_ru'] as String : app['title_en'] as String,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A2540),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _currentLang == 'ru' ? app['desc_ru'] as String : app['desc_en'] as String,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.55,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
      // ==================== FOOTER BRAND ====================
  Widget _buildFooterBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _scrollToTop,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Image.asset(
              'assets/logo.png',
              height: 62,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 62,
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('GeoSib', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0A2540))),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _currentLang == 'ru'
              ? 'Геоматериалы, на которых стоит Сибирь'
              : 'Geosynthetics on which Siberia stands',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ==================== FOOTER LINK ====================
  Widget _footerLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16.5,
          ),
        ),
      ),
    );
  }

  // ==================== FOOTER NAV ====================
  Widget _buildFooterNav() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentLang == 'ru' ? 'Навигация' : 'Navigation',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        _footerLink(_currentLang == 'ru' ? 'О нас' : 'About Us', () => _scrollToKey(_aboutKey)),
        _footerLink(_currentLang == 'ru' ? 'Преимущества' : 'Advantages', () => _scrollToKey(_advantagesKey)),
        _footerLink(_currentLang == 'ru' ? 'Продукция' : 'Products', () => _scrollToKey(_productsKey)),
        _footerLink(_currentLang == 'ru' ? 'Контакты' : 'Contacts', () => _scrollToKey(_contactsKey)),
      ],
    );
  }

  // ==================== FOOTER CONTACTS ====================
  Widget _buildFooterContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentLang == 'ru' ? 'Контакты' : 'Contacts',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: () => _launchPhone('+79829759075'),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              '+7 (982) 975-90-75',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        GestureDetector(
          onTap: () => _launchEmail('td_ssk@bk.ru'),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              'td_ssk@bk.ru',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== FOOTER SOCIAL ====================
  Widget _buildFooterSocial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentLang == 'ru' ? 'Мы в мессенджерах' : 'Messengers',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            IconButton(
              onPressed: _openTelegram,
              icon: const Icon(Icons.telegram, color: Colors.white, size: 38),
              splashRadius: 28,
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat, color: Colors.white, size: 38),
              splashRadius: 28,
            ),
          ],
        ),
      ],
    );
  }
}
