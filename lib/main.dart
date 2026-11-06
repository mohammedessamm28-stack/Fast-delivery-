import 'package:flutter/material.dart';

void main() {
  runApp(const FastDeliveryApp());
}

class FastDeliveryApp extends StatelessWidget {
  const FastDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Delivery',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
        fontFamily: 'Arial',
      ),
      home: const OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final senderController = TextEditingController();
  final senderPhoneController = TextEditingController();
  final receiverController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  final Map<String, int> prices = {
    'داخل كفر الدوار': 25,
    'انطونيادس': 35,
    'الكينج': 35,
    'الحرير': 45,
    'البيضا': 50,
    'الوكيل': 35,
    'الوسطانية': 40,
    'كوم البركة': 50,
    'سيدي غازي': 70,
    'زهرة': 70,
    'معمل القزاز': 70,
    'النشو البحري': 50,
    'بولين': 80,
    'الإسكندرية': 95,
    'العجمي': 100,
    'البحيرة': 85,
    'القاهرة والجيزة': 120,
    'خط الصعيد': 130,
    'باقي المحافظات': 125,
    'خط الساحل': 140,
    'شرم الشيخ والغردقة ودهب': 170,
  };

  String? selectedDestination;
  String payment = 'كاش';

  @override
  void dispose() {
    senderController.dispose();
    senderPhoneController.dispose();
    receiverController.dispose();
    receiverPhoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void showOrder() {
    if (senderController.text.isEmpty ||
        senderPhoneController.text.isEmpty ||
        receiverController.text.isEmpty ||
        receiverPhoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أكمل بيانات الطلب')),
      );
      return;
    }

    final price = prices[selectedDestination]!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مراجعة الطلب'),
        content: Text(
          'المرسل: ${senderController.text}\n'
          'هاتف المرسل: ${senderPhoneController.text}\n'
          'المستلم: ${receiverController.text}\n'
          'هاتف المستلم: ${receiverPhoneController.text}\n'
          'الوجهة: $selectedDestination\n'
          'العنوان: ${addressController.text}\n'
          'السعر: $price جنيه\n'
          'الدفع: $payment\n'
          'ملاحظات: ${notesController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تمام'),
          ),
        ],
      ),
    );
  }

  Widget field(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          title: const Text('Fast Delivery'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'اطلب شحنتك بسهولة 🚚',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('بيانات المرسل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            field('اسم المرسل', senderController),
            field('رقم هاتف المرسل', senderPhoneController,
                type: TextInputType.phone),
            const Divider(height: 25),
            const Text('بيانات المستلم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            field('اسم المستلم', receiverController),
            field('رقم هاتف المستلم', receiverPhoneController,
                type: TextInputType.phone),
            field('العنوان بالتفصيل', addressController),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDestination,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'اختر الوجهة',
                border: OutlineInputBorder(),
              ),
              items: prices.keys.map((destination) {
                return DropdownMenuItem(
                  value: destination,
                  child: Text(
                    '$destination - ${prices[destination]} جنيه',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedDestination = value);
              },
            ),
            const SizedBox(height: 15),
            if (selectedDestination != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'سعر التوصيل: ${prices[selectedDestination]} جنيه',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 15),
            const Text('طريقة الدفع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('كاش'),
              value: 'كاش',
              groupValue: payment,
              onChanged: (value) => setState(() => payment = value!),
            ),
            RadioListTile<String>(
              title: const Text('فودافون كاش'),
              value: 'فودافون كاش',
              groupValue: payment,
              onChanged: (value) => setState(() => payment = value!),
            ),
            field('ملاحظات إضافية', notesController),
            const SizedBox(height: 15),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: showOrder,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'مراجعة الطلب',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('للتواصل: 01228250978'),
            ),
          ],
        ),
      ),
    );
  }
}
