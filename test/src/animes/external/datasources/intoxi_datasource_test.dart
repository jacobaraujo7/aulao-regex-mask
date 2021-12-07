import 'package:flutter_parquinho/src/animes/domain/dtos/anime_post_dto.dart';
import 'package:flutter_parquinho/src/animes/external/datasources/intoxi_datasource.dart';
import 'package:flutter_parquinho/src/animes/infra/datasources/anime_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uno/uno.dart';

class UnoMock extends Mock implements Uno {}

class ResponseMock extends Mock implements Response {}

void main() {
  late Uno uno;
  late AnimeDatasource datasource;
  late Response response;

  setUp(() {
    uno = UnoMock();
    datasource = IntoxiDatasource(uno);
    response = ResponseMock();
  });

  test('Deve retornar uma lista de animes', () async {
    // arrange
    final params = AnimePostDTO(page: 1);
    when(() => response.data).thenReturn(jsonResponse);
    when(() => uno.get(any())).thenAnswer((_) async => response);
    // act
    final result = await datasource.getAnimesByPage(params: params);
    // expects
    expect(result.length, 1);
    expect(result[0].title, 'Titulo');
    expect(result[0].url, 'url-do-post');
  });
}

const jsonResponse = [
  {
    'title': {'rendered': 'Titulo'},
    'link': 'url-do-post',
  }
];
