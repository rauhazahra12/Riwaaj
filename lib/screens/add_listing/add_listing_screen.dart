import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/outfit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key, required this.onPublished});

  final VoidCallback onPublished;

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  int _currentStep = 0;
  final Set<int> _selectedPhotoSlots = {0, 1};
  final ImagePicker _picker = ImagePicker();
  final Map<int, Uint8List> _pickedImages = {};

  // Form Fields
  final _titleController = TextEditingController(
    text: 'Crimson Velvet Bridal Lehenga',
  );
  final _designerController = TextEditingController(text: 'Sania Maskatiya');
  final _descController = TextEditingController(
    text: 'Opulent crimson velvet lehenga with zardozi borders and hand-woven organza veil.',
  );
  final _priceController = TextEditingController(text: '14500');
  final _depositController = TextEditingController(text: '28000');
  final _availabilityController = TextEditingController(text: '15–28 December');

  String _selectedCategory = 'Lehenga';
  String _selectedCity = 'Lahore';
  final Set<String> _selectedSizes = {'M', 'L'};

  @override
  void dispose() {
    _titleController.dispose();
    _designerController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final auth = context.read<AuthProvider>();
    final outfitProvider = context.read<OutfitProvider>();

    final price = double.tryParse(_priceController.text) ?? 10000;
    final deposit = double.tryParse(_depositController.text) ?? 20000;

    final newOutfit = OutfitModel(
      id: 'outfit_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      subtitle: 'NEW ARRIVAL',
      description: _descController.text.trim(),
      designer: _designerController.text.trim(),
      category: _selectedCategory,
      availableSizes: _selectedSizes.toList(),
      pricePerDay: price,
      deposit: deposit,
      city: _selectedCity,
      ownerId: auth.user?.id ?? 'usr_ayesha_01',
      ownerName: auth.user?.name ?? 'Ayesha Khan',
      ownerRating: 5.0,
      isOwnerVerified: true,
      artIndex: 0,
      imageUrl: null,
      availabilityRange: _availabilityController.text.trim(),
      isPromoted: true,
      bookingCount: 0,
    );

    final ok = await outfitProvider.addListing(newOutfit);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Outfit listing published successfully!'),
          backgroundColor: AppColors.green,
        ),
      );
      setState(() => _currentStep = 0);
      widget.onPublished();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            outfitProvider.errorMessage ?? 'Could not publish listing.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List an outfit',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),

              // Step Bar
              Row(
                children: [
                  _stepIndicator(
                    '1. Photos',
                    _currentStep >= 0,
                    _currentStep == 0,
                  ),
                  const SizedBox(width: 8),
                  _stepIndicator(
                    '2. Details',
                    _currentStep >= 1,
                    _currentStep == 1,
                  ),
                  const SizedBox(width: 8),
                  _stepIndicator(
                    '3. Terms',
                    _currentStep >= 2,
                    _currentStep == 2,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Text(
                [
                  'Add your best angles.',
                  'Tell its story.',
                  'Set your terms & publish.',
                ][_currentStep],
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: SingleChildScrollView(
                  child: [
                    _buildStepPhotos(),
                    _buildStepDetails(),
                    _buildStepTerms(),
                  ][_currentStep],
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: SecondaryOutlineButton(
                        text: 'Back',
                        onPressed: () => setState(() => _currentStep--),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: _currentStep < 2 ? 'Continue' : 'Publish listing',
                      onPressed: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          _publish();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepIndicator(String label, bool isDone, bool isCurrent) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.red
                  : isDone
                  ? AppColors.green
                  : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? AppColors.ink : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(int slotIndex, ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _pickedImages[slotIndex] = bytes;
          _selectedPhotoSlots.add(slotIndex);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not access image: $e')));
      }
    }
  }

  void _showSourcePicker(int slotIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Outfit Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Capture live or pick from your saved garment photos',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.blush,
                  child: Icon(Icons.camera_alt_outlined, color: AppColors.red),
                ),
                title: const Text(
                  'Take photo with Camera',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text('Use your device camera for a fresh shot'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(slotIndex, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.sage,
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.green,
                  ),
                ),
                title: const Text(
                  'Upload from Gallery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text('Choose from your device library'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(slotIndex, ImageSource.gallery);
                },
              ),
              if (_pickedImages.containsKey(slotIndex)) ...[
                const Divider(color: AppColors.border),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xfffde8e8),
                    child: Icon(Icons.delete_outline, color: AppColors.red),
                  ),
                  title: const Text(
                    'Remove this photo',
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _pickedImages.remove(slotIndex);
                      _selectedPhotoSlots.remove(slotIndex);
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload 3 to 6 high resolution photos showing front, back, fabric embroidery details, and styling.',
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: List.generate(4, (i) {
            final hasImage = _pickedImages.containsKey(i);
            final isAdded = _selectedPhotoSlots.contains(i);

            return InkWell(
              onTap: () => _showSourcePicker(i),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isAdded ? AppColors.blush : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAdded ? AppColors.red : AppColors.border,
                    width: isAdded ? 1.5 : 1,
                  ),
                ),
                child: hasImage
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(_pickedImages[i]!, fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: AppColors.ink,
                                ),
                                onPressed: () => _showSourcePicker(i),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isAdded
                                ? Icons.check_circle
                                : Icons.add_a_photo_outlined,
                            color: isAdded ? AppColors.red : AppColors.muted,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            hasImage
                                ? 'Photo loaded ✓'
                                : (isAdded
                                      ? 'Angle added ✓'
                                      : (i == 0 ? 'Main Photo' : 'Add Photo')),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isAdded ? AppColors.red : AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Camera / Gallery',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Listing Title',
          hintText: 'e.g. Ruby Farshi Lehenga',
          controller: _titleController,
        ),
        CustomTextField(
          label: 'Designer / Boutique',
          hintText: 'e.g. Elan, Zara Shahjahan',
          controller: _designerController,
        ),
        const Text(
          'CATEGORY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AppConstants.categories.where((c) => c != 'All').map((cat) {
            final isSel = _selectedCategory == cat;
            return CustomChip(
              label: cat,
              isSelected: isSel,
              onTap: () => setState(() => _selectedCategory = cat),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'AVAILABLE SIZES',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AppConstants.sizes.map((s) {
            final isSel = _selectedSizes.contains(s);
            return CustomChip(
              label: s,
              isSelected: isSel,
              onTap: () {
                setState(() {
                  if (isSel) {
                    _selectedSizes.remove(s);
                  } else {
                    _selectedSizes.add(s);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Story & Fabric Details',
          hintText: 'Describe embroidery, fabric, and styling tips...',
          controller: _descController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildStepTerms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Rental Price per day (PKR)',
          hintText: '12500',
          controller: _priceController,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(
          label: 'Refundable Security Deposit (PKR)',
          hintText: '25000',
          controller: _depositController,
          keyboardType: TextInputType.number,
        ),
        CustomTextField(
          label: 'Available Dates',
          hintText: 'e.g. 15–28 December',
          controller: _availabilityController,
        ),
        const Text(
          'PICKUP CITY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: AppConstants.cities.map((c) {
            final isSel = _selectedCity == c;
            return CustomChip(
              label: c,
              isSelected: isSel,
              onTap: () => setState(() => _selectedCity = c),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.sage,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.green, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Riwaaj holds the security deposit until the outfit is verified and returned.',
                  style: TextStyle(color: AppColors.green, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
