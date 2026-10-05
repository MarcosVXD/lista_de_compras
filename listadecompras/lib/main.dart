import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const TelaLista(),
    );
  }
}

// Modelo do item da lista
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // Lista que guarda os itens
  final List<Item> _itens = [];

  // Abre a tela para adicionar um item
  void abrirTelaAdicionar() async {
    final item = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (item != null) {
      setState(() {
        _itens.add(item);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1565C0),
          content: Text('${item.nome} adicionado à lista'),
        ),
      );
    }
  }

  // NOVO: Abre a tela para editar um item
  void editarItem(int indice) async {
    final item = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAdicionarItem(
          item: _itens[indice],
        ),
      ),
    );

    if (item != null) {
      setState(() {
        _itens[indice] = item;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1565C0),
          content: Text('${item.nome} atualizado'),
        ),
      );
    }
  }

  // Remove um item da lista
  void removerItem(int indice) {
    final item = _itens[indice];

    setState(() {
      _itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1565C0),
        content: Text('${item.nome} removido da lista'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int comprados = 0;

    for (final item in _itens) {
      if (item.comprado) {
        comprados++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Compras',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Organize suas compras',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 12,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  '$comprados de ${_itens.length} comprados',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 90,
        ),
        itemCount: _itens.length,
        itemBuilder: (context, indice) {
          final item = _itens[indice];

          return Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: item.comprado
                    ? Colors.transparent
                    : const Color(0xFFE1E7EF),
              ),
            ),
            child: ListTile(
              // NOVO: tocar no item abre a edição
              onTap: () {
                editarItem(indice);
              },

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),

              leading: Checkbox(
                value: item.comprado,
                activeColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onChanged: (valor) {
                  setState(() {
                    item.comprado = valor!;
                  });
                },
              ),

              title: Text(
                item.nome,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: item.comprado
                      ? Colors.grey
                      : const Color(0xFF263238),
                  decoration: item.comprado
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 15,
                      color: Color(0xFF1565C0),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Quantidade: ${item.quantidade}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF1565C0),
                ),
                onPressed: () {
                  removerItem(indice);
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: abrirTelaAdicionar,
        icon: const Icon(Icons.add),
        label: const Text(
          'Adicionar item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  // NOVO: recebe um item quando for edição
  final Item? item;

  const TelaAdicionarItem({
    super.key,
    this.item,
  });

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // Controller para pegar o nome digitado
  final TextEditingController _nomeController =
      TextEditingController();

  // Controller para pegar a quantidade digitada
  final TextEditingController _quantidadeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // NOVO: preenche os campos quando estiver editando
    if (widget.item != null) {
      _nomeController.text = widget.item!.nome;
      _quantidadeController.text =
          widget.item!.quantidade.toString();
    }
  }

  // Salva o novo item
  void salvar() {
    final nome = _nomeController.text.trim();
    final quantidadeTexto =
        _quantidadeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF1565C0),
          content: Text('Digite o nome do item'),
        ),
      );
      return;
    }

    int quantidade = int.tryParse(quantidadeTexto) ?? 1;

    final item = Item(
      nome: nome,
      quantidade: quantidade,
      // NOVO: mantém o status comprado ao editar
      comprado: widget.item?.comprado ?? false,
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null ? 'Novo Item' : 'Editar Item',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item == null
                  ? 'Adicionar à lista'
                  : 'Editar item',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Informe o produto e a quantidade.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _nomeController,

              // NOVO: permite somente letras e espaços
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-ZÀ-ÿ ]'),
                ),
              ],

              decoration: InputDecoration(
                labelText: 'Nome do item',
                prefixIcon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF1565C0),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1565C0),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: Color(0xFF1565C0),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1565C0),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.item == null ? 'Salvar' : 'Salvar alterações',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}