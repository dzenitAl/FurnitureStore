import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/widgets/custom_dropdown_field.dart';
import 'package:furniturestore_admin/widgets/custom_text_field.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:furniturestore_admin/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_admin/utils/utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SubcategoryProvider _subcategoryProvider;
  late ProductProvider _productProvider;
  List<File> _imageFiles = [];
  List<ProductPicturesModel> _existingImages = [];
  SearchResult<SubcategoryModel>? subcategoryResult;
  bool isLoading = true;
  bool _isUploadingImages = false;
  final _baseUrl = 'http://localhost:7015';

  @override
  void initState() {
    super.initState();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _productProvider = context.read<ProductProvider>();
    _initForm();
  }

  Future<void> _initForm() async {
    setState(() {
      isLoading = true;
    });

    try {
      subcategoryResult = await _subcategoryProvider.get();

      if (widget.product?.id != null) {
        final refreshedProduct =
            await _productProvider.getById(widget.product!.id!);

        await _loadExistingImages(widget.product!.id!);
      }
    } catch (e) {
      _logDebug('Error in _initForm: $e');
      _showSnackBar('Error loading form data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadExistingImages(int productId) async {
    try {
      setState(() {
        _existingImages = [];
      });

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url = '$_baseUrl/api/ProductPicture/GetByProductId/$productId';
      _logDebug('Loading images from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;

        if (jsonData.isEmpty) {
          _logDebug('No images found for product $productId');
          return;
        }

        setState(() {
          _existingImages = jsonData
              .map((item) => ProductPicturesModel.fromJson(item))
              .toList();
        });

        _logDebug(
            'Loaded ${_existingImages.length} images for product $productId');

        for (var img in _existingImages) {
          if (img.id != null) {
            await _preloadImage(img.id!, img.imagePath);
          }
        }
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

  Future<bool> _preloadImage(int imageId, String? imagePath) async {
    try {
      final directUrl = '$_baseUrl/api/ProductPicture/direct-image/$imageId';
      _logDebug('Preloading image: $directUrl');

      var imageResponse = await http.get(
        Uri.parse(directUrl),
        headers: {'Authorization': 'Bearer ${Authorization.token}'},
      );

      if (imageResponse.statusCode == 200 &&
          imageResponse.bodyBytes.isNotEmpty) {
        _logDebug('Successfully preloaded image ID $imageId');
        return true;
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        final pathUrl = '$_baseUrl$imagePath';
        _logDebug('Trying alternate path: $pathUrl');

        imageResponse = await http.get(
          Uri.parse(pathUrl),
          headers: {'Authorization': 'Bearer ${Authorization.token}'},
        );

        if (imageResponse.statusCode == 200 &&
            imageResponse.bodyBytes.isNotEmpty) {
          _logDebug('Successfully preloaded image by path');
          return true;
        }
      }

      _logDebug('Failed to preload image ID $imageId');
      return false;
    } catch (e) {
      _logDebug('Error preloading image ID $imageId: $e');
      return false;
    }
  }

  Future<void> _checkProductImages(int productId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url = '$_baseUrl/api/ProductPicture/GetByProductId/$productId';
      _logDebug('Checking product images at: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        _logDebug('Found ${jsonData.length} images for product $productId');

        for (int i = 0; i < jsonData.length; i++) {
          final imageData = jsonData[i];
          final imageId = imageData['id'];
          final imagePath = imageData['imagePath'];

          _logDebug('Image #${i + 1}: ID=$imageId, Path=$imagePath');

          final directUrl =
              '$_baseUrl/api/ProductPicture/direct-image/$imageId';
          _logDebug('Testing direct image access: $directUrl');

          try {
            final imageResponse = await http.get(
              Uri.parse(directUrl),
              headers: headers,
            );
            _logDebug(
                'Direct image response: ${imageResponse.statusCode} (${imageResponse.contentLength} bytes)');
          } catch (e) {
            _logDebug('Error accessing direct image: $e');
          }

          if (imagePath != null && imagePath.isNotEmpty) {
            final pathUrl = '$_baseUrl$imagePath';
            _logDebug('Testing path URL: $pathUrl');

            try {
              final pathResponse = await http.get(
                Uri.parse(pathUrl),
                headers: headers,
              );
              _logDebug(
                  'Path URL response: ${pathResponse.statusCode} (${pathResponse.contentLength} bytes)');
            } catch (e) {
              _logDebug('Error accessing path URL: $e');
            }
          }
        }
      } else {
        _logDebug('Failed to get product images: ${response.statusCode}');
      }
    } catch (e) {
      _logDebug('Error checking product images: $e');
    }
  }

  Future<bool> _testApiConfiguration() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/ProductPicture/test-config'),
      );

      if (response.statusCode == 200) {
        final configData = jsonDecode(response.body);
        print('API Configuration: $configData');

        if (configData['directoryExists'] == true &&
            configData['isWritable'] == true) {
          return true;
        } else {
          _showSnackBar(
              'Server directory issue: Exists=${configData['directoryExists']}, Writable=${configData['isWritable']}');
          return false;
        }
      } else {
        _showSnackBar(
            'Failed to test API configuration: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showSnackBar('Error testing API configuration: $e');
      print('Error testing API configuration: $e');
      return false;
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles = [
          ..._imageFiles,
          ...pickedFiles.map((pickedFile) => File(pickedFile.path)).toList()
        ];
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _removeExistingImage(int index, int imageId) async {
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _refreshProductData() async {
    if (widget.product?.id == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final refreshedProduct =
          await _productProvider.getById(widget.product!.id!);

      await _loadExistingImages(widget.product!.id!);

      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue({
          'name': refreshedProduct.name,
          'description': refreshedProduct.description ?? "",
          'barcode': refreshedProduct.barcode,
          'price': refreshedProduct.price?.toString(),
          'dimensions': refreshedProduct.dimensions ?? "",
          'isAvailableInStore': refreshedProduct.isAvailableInStore ?? false,
          'isAvailableOnline': refreshedProduct.isAvailableOnline ?? false,
          'subcategoryId': refreshedProduct.subcategoryId?.toString(),
        });
      }
    } catch (e) {
      _logDebug('Error refreshing product data: $e');
      _showSnackBar('Failed to refresh product data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final productData = _formKey.currentState!.value;

      if (Authorization.token == null) {
        _showSnackBar('You are not authenticated. Please log in again.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        int productId;
        ProductModel savedProduct;

        if (widget.product != null) {
          savedProduct = await _productProvider.update(
              widget.product!.id as int, productData);
          productId = widget.product!.id!;
          _showSnackBar('Product updated successfully');
        } else {
          savedProduct = await _productProvider.insert(productData);
          productId = savedProduct.id!;
          _showSnackBar('Product created successfully');
        }

        if (_imageFiles.isNotEmpty) {
          setState(() {
            _isUploadingImages = true;
          });

          await _uploadImagesForProduct(productId);

          setState(() {
            _isUploadingImages = false;
          });
        }

        await Future.delayed(const Duration(milliseconds: 500));

        await _loadExistingImages(productId);

        Navigator.pop(context, true);
      } catch (e) {
        _showSnackBar('Error saving: $e');
        _logDebug('Exception saving product: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
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

  Future<bool> _checkFolderStatus() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url = '$_baseUrl/api/ProductPicture/folder-check';
      _logNetworkRequest('GET', url, headers, null);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logDebug('Folder check data: $data');
        final folderExists = data['folderExists'] ?? false;
        final isWritable = data['isWritable'] ?? false;

        if (!folderExists || !isWritable) {
          _showSnackBar(
              'Storage folder issues: Exists=$folderExists, Writable=$isWritable');
          return false;
        }

        _logDebug(
            'Images folder OK (exists=$folderExists, writable=$isWritable)');
        return true;
      } else if (response.statusCode == 401) {
        _showSnackBar('Unauthorized: Please log in again');
        return false;
      } else {
        _showSnackBar('Error checking folder: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _showSnackBar('Error checking folder: $e');
      _logDebug('Exception checking folder: $e');
      return false;
    }
  }

  Future<void> _testDirectFilePaths() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url = '$_baseUrl/api/ProductPicture/direct-file-test';
      _logNetworkRequest('GET', url, headers, null);

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logDebug('Direct file test results: $data');

        if (data['TestUrls'] != null) {
          for (var key in (data['TestUrls'] as Map).keys) {
            final testUrl = data['TestUrls'][key];
            final fullUrl = '$_baseUrl$testUrl';
            _logDebug('Testing URL access: $fullUrl');

            try {
              final testResponse = await http.get(
                Uri.parse(fullUrl),
                headers: {'Authorization': 'Bearer ${Authorization.token}'},
              );
              _logDebug('Test URL response: ${testResponse.statusCode}');
              if (testResponse.statusCode == 200) {
                _logDebug('File content: ${testResponse.body}');
                _showSnackBar('Test file successfully accessed: $key');
                break;
              }
            } catch (e) {
              _logDebug('Error accessing test URL: $e');
            }
          }
        }
      } else {
        _showSnackBar(
            'Error testing direct file paths: ${response.statusCode}');
      }
    } catch (e) {
      _logDebug('Exception testing direct file paths: $e');
    }
  }

  Future<void> _uploadImagesForProduct(int productId) async {
    if (_imageFiles.isEmpty) return;

    await _testDirectFilePaths();

    try {
      final uri = Uri.parse('$_baseUrl/api/ProductPicture/uploadImages');
      _logDebug(
          'Uploading ${_imageFiles.length} images for product $productId');

      var request = http.MultipartRequest('POST', uri)
        ..fields['productId'] = productId.toString();

      if (Authorization.token != null) {
        request.headers['Authorization'] = 'Bearer ${Authorization.token}';
        _logNetworkRequest('POST', uri.toString(), request.headers,
            'multipart form with ${_imageFiles.length} images');
      } else {
        _showSnackBar('Authentication token is missing. Please log in again.');
        return;
      }

      for (var imageFile in _imageFiles) {
        var imageBytes = await imageFile.readAsBytes();
        if (imageBytes.isNotEmpty) {
          request.files.add(http.MultipartFile.fromBytes('images', imageBytes,
              filename: imageFile.path.split('/').last));
          _logDebug(
              'Added image: ${imageFile.path.split('/').last} (${imageBytes.length} bytes)');
        } else {
          _showSnackBar('Error: Image is empty');
          return;
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      _logNetworkResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        _showSnackBar('Images uploaded successfully');

        if (widget.product != null) {
          await _loadExistingImages(widget.product!.id!);
        }
      } else if (response.statusCode == 401) {
        _showSnackBar('Unauthorized: Please log in again');
      } else {
        _showSnackBar('Failed to upload images: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Error uploading images: $e');
      _logDebug('Exception during upload: $e');
    }
  }

  Future<bool> _checkImageExists(String imagePath) async {
    try {
      final imageUrl = '$_baseUrl$imagePath';
      final response = await http.head(
        Uri.parse(imageUrl),
        headers: {'Authorization': 'Bearer ${Authorization.token}'},
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      _logDebug('Error checking if image exists: $e');
      return false;
    }
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

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.product != null
                ? 'Informacije o proizvodu ${widget.product!.name}'
                : 'Dodaj informacije za novi proizvod',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),
        ),
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
                        'name': widget.product?.name,
                        'description': widget.product?.description ?? "",
                        'barcode': widget.product?.barcode,
                        'price': widget.product?.price?.toString(),
                        'dimensions': widget.product?.dimensions ?? "",
                        'isAvailableInStore':
                            widget.product?.isAvailableInStore ?? false,
                        'isAvailableOnline':
                            widget.product?.isAvailableOnline ?? false,
                        'subcategoryId':
                            widget.product?.subcategoryId?.toString(),
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow([
                              const CustomTextField(
                                  name: 'name',
                                  label: 'Naziv',
                                  isRequired: true),
                              CustomTextField(
                                name: 'barcode',
                                label: 'Barkod',
                                isRequired: true,
                                validators: [
                                  FormBuilderValidators.minLength(6,
                                      errorText:
                                          'Barkod mora imati najmanje 6 znakova'),
                                  FormBuilderValidators.maxLength(15,
                                      errorText:
                                          'Barkod ne smije imati više od 15 znakova'),
                                  FormBuilderValidators.match(
                                    r'^[a-zA-Z0-9]+$',
                                    errorText:
                                        'Barkod smije sadržavati samo slova i brojeve',
                                  ),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildRow([
                              CustomDropdownField(
                                name: 'subcategoryId',
                                label: 'Potkategorija',
                                isRequired: true,
                                formKey: _formKey,
                                items: subcategoryResult?.result
                                        .map((subcategory) {
                                      return DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: subcategory.id.toString(),
                                        child: Text(subcategory.name ?? ''),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSwitchField('isAvailableInStore',
                                      'Dostupno u radnji'),
                                  _buildSwitchField(
                                      'isAvailableOnline', 'Dostupno online'),
                                ],
                              ),
                            ]),
                            const SizedBox(height: 16),
                            _buildRow([
                              CustomTextField(
                                name: 'price',
                                label: 'Cijena',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                validators: [
                                  FormBuilderValidators.min(0.01,
                                      errorText:
                                          'Cijena mora biti veća od nule'),
                                ],
                              ),
                              CustomTextField(
                                name: 'dimensions',
                                label: 'Dimenzije',
                                isRequired: false,
                                validators: [
                                  FormBuilderValidators.match(
                                    r'^\d+(\.\d+)?\s*x\s*\d+(\.\d+)?\s*x\s*\d+(\.\d+)?$',
                                    errorText:
                                        'Unesite dimenzije u formatu D x Š x V, npr. 200 x 100 x 50',
                                  ),
                                ],
                                keyboardType: TextInputType.text,
                                hintText:
                                    'Unesite dimenzije u formatu D x Š x V',
                              ),
                            ]),
                            const SizedBox(height: 16),
                            const CustomTextField(
                                name: 'description',
                                label: 'Opis',
                                maxLines: 3),
                            const SizedBox(height: 16),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Slike proizvoda',
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageFiles.length,
                              itemBuilder: (context, index) {
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
                                      child: Image.file(
                                        _imageFiles[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 13,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
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
                        ] else if (_existingImages.isEmpty) ...[
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Nema izabranih slika',
                                style: TextStyle(color: Colors.grey),
                              ),
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
            onPressed: _isUploadingImages ? null : _onSubmit,
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
                : const Text('Save'),
          ),
        ),
        const SizedBox(height: 20),
      ],
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showBackButton: true,
      title: widget.product != null
          ? 'Informacije o proizvodu ${widget.product!.name}'
          : 'Dodaj informacije za novi proizvod',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  void _debugImageDetails() {
    if (_existingImages.isEmpty) {
      _logDebug('No existing images to debug');
      return;
    }

    _logDebug('========= Image Details Debug =========');
    for (int i = 0; i < _existingImages.length; i++) {
      final image = _existingImages[i];
      _logDebug('Image #${i + 1}:');
      _logDebug('  ID: ${image.id}');
      _logDebug('  Path: ${image.imagePath}');
      if (image.imagePath != null) {
        final imageUrl = '$_baseUrl${image.imagePath}';
        _logDebug('  Full URL: $imageUrl');
      }
      _logDebug('-----------------------------------');
    }
  }
}
