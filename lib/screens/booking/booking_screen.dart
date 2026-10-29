import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/outfit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.outfit,
    required this.onBack,
    required this.onSuccess,
  });

  final OutfitModel outfit;
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _startDay = 12;
  int _endDay = 15;
  late final TextEditingController _sizeController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _sizeController = TextEditingController(
      text: widget.outfit.availableSizes.isNotEmpty
          ? widget.outfit.availableSizes.first
          : 'M',
    );
    _noteController = TextEditingController(
      text: 'Hello ${widget.outfit.ownerName}! I would love to rent this stunning piece.',
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int get _daysCount => (_endDay - _startDay + 1).clamp(1, 14);

  double get _rentalTotal => widget.outfit.pricePerDay * _daysCount;
  double get _serviceFee => _rentalTotal * AppConstants.serviceFeePercentage;
  double get _deposit => widget.outfit.deposit;
  double get _totalAmount => _rentalTotal + _serviceFee + _deposit;

  Future<void> _submitBooking() async {
    final bookingProvider = context.read<BookingProvider>();
    final auth = context.read<AuthProvider>();

    final now = DateTime.now();
    final startDate = DateTime(now.year, 12, _startDay);
    final endDate = DateTime(now.year, 12, _endDay);

    final ok = await bookingProvider.createRentalRequest(
      outfit: widget.outfit,
      startDate: startDate,
      endDate: endDate,
      selectedSize: _sizeController.text.trim(),
      note: _noteController.text.trim(),
      renterId: auth.user?.id ?? 'usr_ayesha_01',
      renterName: auth.user?.name ?? 'Ayesha Khan',
    );

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rental request sent to ${widget.outfit.ownerName}!'),
          backgroundColor: AppColors.green,
        ),
      );
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 12),
              Text(
                'Make it yours.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose rental dates and send your request to the owner.',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Outfit Summary Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.checkroom, color: AppColors.red, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.outfit.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            '${Formatters.pkr(widget.outfit.pricePerDay)} / day · ${widget.outfit.city}',
                            style: const TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calendar Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DECEMBER 2026',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    '$_daysCount days selected',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Interactive Calendar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Day of week labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DayHeader('Mo'),
                        _DayHeader('Tu'),
                        _DayHeader('We'),
                        _DayHeader('Th'),
                        _DayHeader('Fr'),
                        _DayHeader('Sa'),
                        _DayHeader('Su'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Days grid
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(31, (i) {
                        final day = i + 1;
                        final isSelected = day >= _startDay && day <= _endDay;
                        final isEdge = day == _startDay || day == _endDay;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (day < _startDay) {
                                _startDay = day;
                              } else {
                                _endDay = day;
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 38,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isEdge
                                  ? AppColors.red
                                  : isSelected
                                      ? AppColors.blush
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isEdge
                                    ? Colors.white
                                    : isSelected
                                        ? AppColors.red
                                        : AppColors.ink,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Your Size',
                hintText: 'e.g. Medium (M)',
                controller: _sizeController,
              ),

              CustomTextField(
                label: 'Note to ${widget.outfit.ownerName}',
                hintText: 'Share any questions or event date details',
                controller: _noteController,
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              // Fee Breakdown Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _breakdownRow(
                      '$_daysCount days × ${Formatters.pkr(widget.outfit.pricePerDay)}',
                      Formatters.pkr(_rentalTotal),
                    ),
                    const SizedBox(height: 6),
                    _breakdownRow(
                      'Riwaaj service fee (15%)',
                      Formatters.pkr(_serviceFee),
                    ),
                    const SizedBox(height: 6),
                    _breakdownRow(
                      'Refundable deposit',
                      Formatters.pkr(_deposit),
                    ),
                    const Divider(height: 20, color: AppColors.border),
                    _breakdownRow(
                      'TOTAL',
                      Formatters.pkr(_totalAmount),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Send rental request',
                isLoading: bookingProvider.isLoading,
                onPressed: _submitBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 13 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.ink : AppColors.muted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.red : AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.muted),
      ),
    );
  }
}
