import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _product = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus &&
        Uri.tryParse(_imageUrlController.text)!.isAbsolute) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_form.currentState!.validate()) {
      _form.currentState?.save();
      if (kDebugMode) {
        print(_product.toString());
      }
      if (_product.id == '') {
        Provider.of<Products>(context, listen: false).addProduct(_product);
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(_product);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _product.title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Provide a title';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _product = Product(
                    id: _product.id,
                    title: newValue!,
                    description: _product.description,
                    price: _product.price,
                    imageUrl: _product.imageUrl,
                    isFavorite: _product.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _product.price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a price.';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  } else if (double.parse(value) <= 0) {
                    return 'Enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _product = Product(
                    id: _product.id,
                    title: _product.title,
                    description: _product.description,
                    price: double.parse(newValue!),
                    imageUrl: _product.imageUrl,
                    isFavorite: _product.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _product.description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a description.';
                  } else if (value.length < 10) {
                    return 'Should be at least 10 character long.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _product = Product(
                    id: _product.id,
                    title: _product.title,
                    description: newValue!,
                    price: _product.price,
                    imageUrl: _product.imageUrl,
                    isFavorite: _product.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (!Uri.tryParse(value!)!.isAbsolute) {
                          return 'Enter an image URL';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _product = Product(
                          id: _product.id,
                          title: _product.title,
                          description: _product.description,
                          price: _product.price,
                          imageUrl: newValue!,
                          isFavorite: _product.isFavorite,
                        );
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
}
