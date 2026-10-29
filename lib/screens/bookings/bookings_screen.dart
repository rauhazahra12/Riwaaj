import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({
    super.key,
    required this.onChatWithOwner,
  });

  final ValueChanged<String> onChatWithOwner;

  void _showTimelineModal(BuildContext context, BookingModel booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Rental Journey',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.outfitTitle} · ${booking.selectedSize}',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _timelineStep(
                title: 'Request sent',
                subtitle: 'Submitted on ${Formatters.formatDate(booking.createdAt)}',
                isDone: true,
                isCurrent: booking.status == BookingStatus.pending,
              ),
              _timelineStep(
                title: 'Accepted by owner',
                subtitle: booking.status == BookingStatus.accepted ||
                        booking.status == BookingStatus.active ||
                        booking.status == BookingStatus.returned
                    ? 'Confirmed by ${booking.ownerName}'
                    : 'Awaiting owner confirmation',
                isDone: booking.status == BookingStatus.accepted ||
                    booking.status == BookingStatus.active ||
                    booking.status == BookingStatus.returned,
                isCurrent: booking.status == BookingStatus.accepted,
              ),
              _timelineStep(
                title: 'Handover & Security Deposit',
                subtitle: 'Scheduled for ${Formatters.formatDate(booking.startDate)}',
                isDone: booking.status == BookingStatus.active ||
                    booking.status == BookingStatus.returned,
                isCurrent: booking.status == BookingStatus.active,
              ),
              _timelineStep(
                title: 'Returned in pristine condition',
                subtitle: 'Return date: ${Formatters.formatDate(booking.endDate)}',
                isDone: booking.status == BookingStatus.returned,
                isLast: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.red),
                  onPressed: () {
                    Navigator.pop(ctx);
                    onChatWithOwner(booking.ownerName);
                  },
                  child: Text('Message ${booking.ownerName}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _timelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.green
                    : isCurrent
                        ? AppColors.gold
                        : AppColors.border,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check : Icons.circle,
                size: isDone ? 14 : 8,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: isDone ? AppColors.green : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDone || isCurrent ? AppColors.ink : AppColors.muted,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final isRenting = bookingProvider.activeTab == 0;
    final bookings = isRenting
        ? bookingProvider.rentingBookings
        : bookingProvider.lendingBookings;

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'the outfit diary',
                style: GoogleFonts.alexBrush(
                  fontSize: 26,
                  color: AppColors.red,
                ),
              ),
              Text(
                'My bookings',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),

              // Segmented Toggle (I'm renting / I'm lending)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _tabButton("I’m renting", isRenting, () {
                        bookingProvider.setActiveTab(0);
                      }),
                    ),
                    Expanded(
                      child: _tabButton("I’m lending", !isRenting, () {
                        bookingProvider.setActiveTab(1);
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Bookings List
              Expanded(
                child: bookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 44,
                              color: AppColors.mutedLight,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isRenting
                                  ? 'No rentals requested yet'
                                  : 'No lending requests received yet',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Your rental timeline and details will appear here.',
                              style: TextStyle(color: AppColors.muted, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final b = bookings[index];
                          final dateStr = Formatters.formatDateRange(
                            b.startDate,
                            b.endDate,
                          );

                          Color statusColor;
                          switch (b.status) {
                            case BookingStatus.accepted:
                            case BookingStatus.active:
                              statusColor = AppColors.green;
                              break;
                            case BookingStatus.pending:
                              statusColor = AppColors.gold;
                              break;
                            case BookingStatus.returned:
                              statusColor = AppColors.blue;
                              break;
                            case BookingStatus.declined:
                              statusColor = AppColors.red;
                              break;
                          }

                          return InkWell(
                            onTap: () => _showTimelineModal(context, b),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
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
                                      color: statusColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.checkroom,
                                      color: statusColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              b.status.displayName,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: statusColor,
                                              ),
                                            ),
                                            Text(
                                              dateStr,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.muted,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          b.outfitTitle,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${Formatters.pkr(b.totalAmount)} · Size ${b.selectedSize} · ${b.days} days',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.mutedLight,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
