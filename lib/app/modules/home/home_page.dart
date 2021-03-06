import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_with_cubit/app/modules/home/cubit/home_cubit.dart';
import 'package:login_with_cubit/app/shared/debouncer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final HomeCubit _cubit = Modular.get<HomeCubit>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            SharedPreferences.getInstance().then((sp){
              sp.clear();
              Modular.to.pushNamed('/');
            });
          })
        ],
      ),
      body: BlocProvider(
        create: (context) => _cubit..findRandomGifs(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Pesquisar', border: OutlineInputBorder()),
                onChanged: (value) => debouncer(() => _cubit.findGif(value)),
              ),
            ),
            buildSelectedGif(),
            buildGifs(),
          ],
        ),
      ),
    );
  }

  Widget buildGifs() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if(state.errorMessage.isNotEmpty) {
          FlutterToast(context).showToast(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.red,
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),);
        }
      },
      builder: (context, state) {
        if (state.loading != null && state.loading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.gifs.isNotEmpty) {
          return buildResult(state);
        }

        return Container();
      },
    );
  }

  Widget buildResult(HomeState state) {
    return Container(
      child: Expanded(
        child: GridView.builder(
          itemCount: state.gifs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            final gif = state.gifs[index];
            return InkWell(
              onTap: () => _cubit.selectGif(gif),
              child: Image.network(
                gif.url,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSelectedGif() {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // print(state.gifSelecionado.id);
      },
      builder: (context, state) {
        if (state.gifSelecionado != null) {
          return Container(
            child: Image.network(
              state.gifSelecionado.url,
              fit: BoxFit.cover,
            ),
          );
        }
        return Container();
      },
    );
  }
}
