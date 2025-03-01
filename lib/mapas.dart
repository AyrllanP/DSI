import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:geocoding/geocoding.dart'; // Importando a dependência de geocodificação
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projeto_dsi/diario_medo.dart';
import 'package:projeto_dsi/habitos.dart';
import 'package:projeto_dsi/perfil.dart';
import 'notas_diarias.dart';
import 'servicos/autenticacao.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapasPage extends StatefulWidget {
  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {
  int _selectedIndex = 3;
  final AutenticacaoServico _authServico = AutenticacaoServico();
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  LatLng _currentPosition = LatLng(-8.0476, -34.8770);
  final TextEditingController _enderecoController = TextEditingController();

  void _fazerLogout() async {
    await _authServico.deslogarUsuario();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout realizado com sucesso!")),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotasDiariaPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiarioMedoPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HabitosPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapasPage()),
        );
        break;
    }
  }

  // Função para fazer a geocodificação do endereço
  Future<void> _buscarCoordenadas(String endereco) async {
    try {
      print("Buscando coordenadas para: $endereco");

      // Verifica se o endereço está vazio
      if (endereco.isEmpty) {
        print("Endereço vazio!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, insira um endereço válido!")),
        );
        return;
      }

      // URL da API do OpenStreetMap Nominatim
      final String url = "https://nominatim.openstreetmap.org/search?format=json&q=$endereco";

      // Faz a requisição HTTP
      print("Fazendo requisição para: $url");
      final response = await http.get(Uri.parse(url));
      print("Resposta da API Nominatim: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Resultados encontrados: ${data.length}");

        if (data.isNotEmpty) {
          // Pega a primeira localização encontrada
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          print("Coordenadas encontradas: $lat, $lon");

          // Atualiza a posição no mapa
          setState(() { 
            _currentPosition = LatLng(lat, lon);
          });

          _mapController.move(_currentPosition, 12);

          // Busca clínicas próximas
          _searchClinics(_currentPosition);
        } else {
          print("Nenhuma localização encontrada para o endereço: $endereco");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Endereço não encontrado!")),
          );
        }
      } else {
        print("Erro na requisição: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao buscar o endereço!")),
        );
      }
    } catch (e) {
      print("Erro ao buscar coordenadas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar o endereço!")),
      );
    }
  }
  // Função para buscar clínicas próximas
  Future<void> _searchClinics(LatLng location) async {
  try {
    String overpassUrl =
        "https://overpass-api.de/api/interpreter?data=[out:json];node(around:5000,${location.latitude},${location.longitude})[amenity=clinic];out;";
    print("Buscando clínicas na URL: $overpassUrl");

    final response = await http.get(Uri.parse(overpassUrl));
    print("Resposta da Overpass API: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Dados recebidos: ${data['elements']}");

      setState(() {
        _markers.clear();
        for (var element in data['elements']) {
          double lat = element['lat'];
          double lon = element['lon'];
          _markers.add(Marker(
            width: 40,
            height: 40,
            point: LatLng(lat, lon),
            child: const Icon(
              Icons.psychology,
              color: Colors.purple,
              size: 30,
            ),
          ));
        }
      });

      if (_markers.isEmpty) {
        print("Nenhuma clínica encontrada nas proximidades.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhuma clínica encontrada!")),
        );
      }
    } else {
      print("Erro na requisição: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar clínicas!")),
      );
    }
  } catch (e) {
    print("Erro ao buscar clínicas: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro ao buscar clínicas!")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaPerfil()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Buscar Clínicas",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _enderecoController,
              decoration: InputDecoration(
                labelText: "Digite o endereço",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String endereco = _enderecoController.text;
                    if (endereco.isNotEmpty) {
                      _buscarCoordenadas(endereco);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  setState(() {
                    _currentPosition = position.center!;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade100,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: "Notas diárias",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.skull),
            label: 'Diário do medo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Hábitos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Maps",
          ),
        ],
      ),
    );
  }
}