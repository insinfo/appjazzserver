import 'dart:async';
import 'dart:core';
import 'package:aqueduct/aqueduct.dart';

//importa os modelos
import 'package:appjazz/model/usuario.dart';

//este controle lista as atrações do festival
class UsuarioController extends ResourceController {
  //contexto para acesso ao banco de dados
  UsuarioController(this.context);

  final ManagedContext context;

  //obtem todas
  @Operation.get()
  Future<Response> getAll() async {
    final query = Query<Usuario>(context)
      ..sortBy((item) => item.nome, QuerySortOrder.ascending);

    final items = await query.fetch();
    return Response.ok(items);
  }

  //obtem uma por id
  @Operation.get('id')
  Future<Response> getById(@Bind.path('id') int id) async {
    final query = Query<Usuario>(context)
      ..where((item) => item.id).equalTo(id);

    final item = await query.fetchOne();

    if (item == null) {
      return Response.notFound();
    }
    return Response.ok(item);
  }

  //cria uma
  @Operation.post()
  Future<Response> create(
      @Bind.body() Usuario inputItem) async {
    final query = Query<Usuario>(context)..values = inputItem;
    final insertedItem = await query.insert();
    return Response.ok(insertedItem);
  }

  //atualiza
  @Operation.put('id')
  Future<Response> updateById(
      @Bind.path('id') int id, @Bind.body() Usuario inputItem) async {
    final query = Query<Usuario>(context)
      ..where((item) => item.id).equalTo(id)
      ..values = inputItem;

    final attraction = await query.updateOne();

    if (attraction == null) {
      return Response.notFound();
    }

    return Response.ok(attraction);
  }

  //deleta
  @Operation.delete('id')
  Future<Response> deleteById(@Bind.path('id') int id) async {
    final query = Query<Usuario>(context)
      ..where((item) => item.id).equalTo(id);

    final item = await query.delete();
    if (item == null) {
      return Response.notFound();
    }
    return Response.ok(item);
  }

}
