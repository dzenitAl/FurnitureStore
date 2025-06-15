import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/providers/decoration_item_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:furniturestore_admin/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DecorationItemDetailScreen extends StatefulWidget {
  final DecorationItemModel? item;

  const DecorationItemDetailScreen({super.key, this.item});

  @override
  State<DecorationItemDetailScreen> createState() =>
      _DecorationItemDetailScreenState();
}

class _DecorationItemDetailScreenState
    extends State<DecorationItemDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late DecorationItemProvider _decorationItemProvider;
  final List<File> _imageFiles = [];
  List<ProductPicturesModel> _existingImages = [];
  bool isLoading = true;
  bool _isUploadingImages = false;
  final _baseUrl = 'http://localhost:7015';
  late CategoryProvider _categoryProvider;
  SearchResult<CategoryModel>? categoryResult;

  @override
  void initState() {
    super.initState();
    _decorationItemProvider = context.read<DecorationItemProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _initForm();
  }

  Future<void> _initForm() async {
    categoryResult = await _categoryProvider.get();

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.item?.id != null) {
        await _loadExistingImages(widget.item!.id!);
      }
    } catch (e) {
      _showSnackBar('Error loading form data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadExistingImages(int itemId) async {
    try {
      setState(() {
        _existingImages = [];
      });

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url =
          '$_baseUrl/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/$itemId';
      _logDebug('Loading images from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;

        if (jsonData.isEmpty) {
          _logDebug('No images found for item $itemId');
          return;
        }

        setState(() {
          _existingImages = jsonData
              .map((item) => ProductPicturesModel.fromJson(item))
              .toList();
        });

        _logDebug('Loaded ${_existingImages.length} images for item $itemId');
      } else if (response.statusCode == 401) {
        _showSnackBar('Unauthorized: Please log in again');
      } else {
        _showSnackBar('Error loading images: ${response.statusCode}');
        _logDebug(
            'Failed to load images: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error loading images: $e');
      _logDebug('Exception loading images: $e');
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.value;
        final item = DecorationItemModel(
          id: widget.item?.id,
          name: formData['name'],
          description: formData['description'],
          price: double.tryParse(formData['price'].toString()),
          dimensions: formData['dimensions'],
          isAvailableInStore: formData['isAvailableInStore'],
          isAvailableOnline: formData['isAvailableOnline'],
          categoryId: int.tryParse(formData['categoryId'].toString()),
          material: formData['material'] ?? '',
          stockQuantity:
              int.tryParse(formData['stockQuantity'].toString()) ?? 0,
          style: formData['style'] ?? '',
          color: formData['color'] ?? '',
          isFragile: formData['isFragile'] ?? false,
          careInstructions: formData['careInstructions'] ?? '',
        );

        int itemId;
        DecorationItemModel savedItem;

        if (widget.item?.id == null) {
          savedItem = await _decorationItemProvider.insert(item);
          itemId = savedItem.id!;
          _showSnackBar('Decoration item created successfully');
        } else {
          savedItem =
              await _decorationItemProvider.update(widget.item!.id!, item);
          itemId = widget.item!.id!;
          _showSnackBar('Decoration item updated successfully');
        }

        if (_imageFiles.isNotEmpty) {
          setState(() {
            _isUploadingImages = true;
          });

          await _uploadImagesForItem(itemId);

          setState(() {
            _isUploadingImages = false;
          });
        }

        await Future.delayed(const Duration(milliseconds: 500));

        await _loadExistingImages(itemId);

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        _showSnackBar('Error saving decoration item: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImagesForItem(int itemId) async {
    if (_imageFiles.isEmpty) return;

    try {
      final uri = Uri.parse('$_baseUrl/api/ProductPicture/uploadEntityImages');
      _logDebug('Uploading ${_imageFiles.length} images for item $itemId');

      var request = http.MultipartRequest('POST', uri)
        ..fields['entityType'] = 'DecorativeItem'
        ..fields['entityId'] = itemId.toString()
        ..fields['replaceExisting'] = 'false';

      if (Authorization.token != null) {
        request.headers['Authorization'] = 'Bearer ${Authorization.token}';
        request.headers['Content-Type'] = 'application/json';
      } else {
        _showSnackBar('Authentication token is missing. Please log in again.');
        return;
      }

      _logNetworkRequest('POST', uri.toString(), request.headers,
          'multipart form with ${_imageFiles.length} images');

      for (var imageFile in _imageFiles) {
        var imageBytes = await imageFile.readAsBytes();
        if (imageBytes.isNotEmpty) {
          request.files.add(http.MultipartFile.fromBytes('images', imageBytes,
              filename: imageFile.path.split('/').last));
          _logDebug(
              'Added image: ${imageFile.path.split('/').last} (${imageBytes.length} bytes)');
        } else {
          _logDebug('Error: Empty image file encountered');
          _showSnackBar('Error: Image is empty');
          return;
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        _showSnackBar('Images uploaded successfully');
        setState(() {
          _imageFiles.clear();
        });
        await _loadExistingImages(itemId);
      } else if (response.statusCode == 401) {
        _showSnackBar('Unauthorized: Please log in again');
      } else {
        _showSnackBar('Failed to upload images: ${response.body}');
        _logDebug(
            'Failed to upload images: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error uploading images: $e');
      _logDebug('Exception during upload: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((widget) {
        return Expanded(child: widget);
      }).toList(),
    );
  }

  Widget _buildSwitchField(String name, String label) {
    return FormBuilderSwitch(
      name: name,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      initialValue: false,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }

  Future<void> _removeExistingImage(int index, int imageId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await http.delete(
          Uri.parse('$_baseUrl/api/ProductPicture/$imageId'),
          headers: {
            'Authorization': 'Bearer ${Authorization.token}',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            _existingImages.removeAt(index);
          });
          _showSnackBar('Image deleted successfully');
        } else {
          _showSnackBar('Failed to delete image: ${response.statusCode}');
        }
      } catch (e) {
        _showSnackBar('Error deleting image: $e');
      }
    }
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: FormBuilder(
                      key: _formKey,
                      initialValue: {
                        'name': widget.item?.name ?? '',
                        'description': widget.item?.description ?? '',
                        'price': widget.item?.price?.toString() ?? '',
                        'dimensions': widget.item?.dimensions ?? '',
                        'isAvailableInStore':
                            widget.item?.isAvailableInStore ?? false,
                        'isAvailableOnline':
                            widget.item?.isAvailableOnline ?? false,
                        'categoryId': widget.item?.categoryId.toString() ?? '',
                        'material': widget.item?.material ?? '',
                        'stockQuantity':
                            widget.item?.stockQuantity.toString() ?? '',
                        'pictures': widget.item?.pictures ?? [],
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow([
                              CustomTextField(
                                name: 'name',
                                label: 'Naziv',
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                              CustomTextField(
                                name: 'price',
                                label: 'Cijena',
                                validators: [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildRow([
                              CustomTextField(
                                name: 'dimensions',
                                label: 'Dimenzije',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSwitchField('isAvailableInStore',
                                      'Dostupno u prodavnici'),
                                  _buildSwitchField(
                                      'isAvailableOnline', 'Dostupno online'),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            CustomTextField(
                              name: 'description',
                              label: 'Opis',
                              maxLines: 3,
                            ),
                            CustomTextField(
                              name: 'material',
                              label: 'Materijal',
                            ),
                            CustomTextField(
                              name: 'stockQuantity',
                              label: 'Količina na skladištu',
                            ),
                            CustomDropdownField(
                              name: 'categoryId',
                              label: 'Kategorija',
                              isRequired: true,
                              formKey: _formKey,
                              items: categoryResult?.result.map((category) {
                                    return DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: category.id.toString(),
                                      child: Text(category.name ?? ''),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Slike predmeta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_existingImages.isNotEmpty) ...[
                          const Text(
                            'Postojeće slike:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _existingImages.length,
                              itemBuilder: (context, index) {
                                final image = _existingImages[index];
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: _buildImageWithAuth(
                                          image.imagePath, image.id),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 13,
                                      child: GestureDetector(
                                        onTap: () => _removeExistingImage(
                                            index, image.id!),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_imageFiles.isNotEmpty) ...[
                          const Text(
                            'Nove slike za upload:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageFiles.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Image.file(_imageFiles[index],
                                      fit: BoxFit.cover),
                                );
                              },
                            ),
                          ),
                        ] else if (_existingImages.isEmpty) ...[
                          const Center(
                            child: Text(
                              'Nema izabranih slika',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Izaberi slike'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D3557),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _isUploadingImages ? null : _saveForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(250, 50),
              backgroundColor: const Color(0xFFF4A258),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: _isUploadingImages
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Uploading...'),
                    ],
                  )
                : const Text('Sačuvaj'),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showBackButton: true,
      title: widget.item != null
          ? 'Informacije o dekorativnom predmetu ${widget.item!.name}'
          : 'Dodaj informacije za novi dekorativni predmet',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  void _logDebug(String message) {
    const bool debugLoggingEnabled = true;
    if (debugLoggingEnabled) {
      print('DEBUG: $message');
    }
  }

  void _logNetworkRequest(
      String method, String url, Map<String, dynamic>? headers, dynamic body) {
    _logDebug('[$method] $url');
    if (headers != null) {
      _logDebug('Headers: ${headers.toString()}');
    }
    if (body != null) {
      _logDebug('Body: $body');
    }
  }

  void _logNetworkResponse(int statusCode, String body) {
    _logDebug('Response: $statusCode');
    _logDebug('Body: $body');
  }

  Widget _buildImageWithAuth(String? imagePath, int? imageId) {
    if (imageId == null) {
      return const Center(child: Text('Missing image ID'));
    }

    return FutureBuilder<Widget>(
      future: _getBestImageWidget(imageId, imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(height: 8),
                Text('Error loading image', textAlign: TextAlign.center),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Widget> _getBestImageWidget(int imageId, String? imagePath) async {
    try {
      final directUrl = '$_baseUrl/api/ProductPicture/direct-image/$imageId';
      final response = await http.head(
        Uri.parse(directUrl),
        headers: {'Authorization': 'Bearer ${Authorization.token}'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Image.network(
          directUrl,
          fit: BoxFit.cover,
          headers: {'Authorization': 'Bearer ${Authorization.token}'},
          errorBuilder: (_, __, ___) {
            return _getPathBasedImage(imagePath);
          },
        );
      }
    } catch (e) {
      _logDebug('Error checking direct image URL: $e');
    }

    return _getPathBasedImage(imagePath);
  }

  Widget _getPathBasedImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_not_supported, color: Colors.grey),
            SizedBox(height: 8),
            Text('No image available', textAlign: TextAlign.center),
          ],
        ),
      );
    }

    final imageUrl = '$_baseUrl$imagePath';
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      headers: {'Authorization': 'Bearer ${Authorization.token}'},
      errorBuilder: (_, __, ___) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image, color: Colors.red),
              SizedBox(height: 8),
              Text('Image not found', textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}
