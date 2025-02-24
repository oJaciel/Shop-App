import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  //Variáveis e métodos de controle do foco
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  //Variáveis e métodos de controle da URL da imagem
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  //Método para validar a URL da imagem informada
  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl == true && endsWithFile == true;
  }

  //Método para submeter formulário e salvar item
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid == false) {
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro!'),
          content: Text('Ocorreu um erro ao salvar o produto!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final argument = ModalRoute.of(context)?.settings.arguments;

      if (argument != null) {
        final product = argument as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    //Campo de Nome
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) {
                        final name = _name ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatório!';
                        }

                        if (name.trim().length < 3) {
                          return 'Nome precisa de no mínimo 3 letas!';
                        }

                        return null;
                      },
                    ),
                    //Campo de preço
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      focusNode: _priceFocus,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (_price) {
                        final priceString = _price ?? '';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido!';
                        }

                        return null;
                      },
                    ),
                    //Campo de descrição
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: InputDecoration(labelText: 'Descrição'),
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocus);
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (_description) {
                        final description = _description ?? '';

                        if (description.trim().isEmpty) {
                          return 'Descrição é obrigatória!';
                        }

                        if (description.trim().length < 10) {
                          return 'Descrição precisa de no mínimo 10 letas!';
                        }

                        return null;
                      },
                    ),
                    //Campo do URL da Imagem
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? '';

                              if (isValidImageUrl(imageUrl) == false) {
                                return 'Informe uma Url válida!';
                              }

                              return null;
                            },
                          ),
                        ),
                        //Container da Imagem da URL (carregada após informar o URL)
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a Url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageUrlController.text),
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
