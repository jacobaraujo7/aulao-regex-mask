import 'package:flutter_parquinho/src/animes/domain/dtos/anime_post_dto.dart';
import 'package:flutter_parquinho/src/animes/domain/errors/errors.dart';
import 'package:flutter_parquinho/src/animes/domain/repositories/anime_repository.dart';
import 'package:flutter_parquinho/src/animes/infra/datasources/anime_datasource.dart';
import 'package:flutter_parquinho/src/animes/infra/repositories/anime_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AnimeDatasourceMock extends Mock implements AnimeDatasource {}

void main() {
  late AnimeRepository repository;
  late AnimeDatasource datasource;

  setUp(() {
    datasource = AnimeDatasourceMock();
    repository = AnimeRepositoryImpl(datasource);
  });

  test('Deve retornar uma lista de animes', () async {
    // arrage
    final params = AnimePostDTO(page: 1);
    when(() => datasource.getAnimesByPage(params: params)).thenAnswer((_) async => []);
    // act
    final result = await repository.getAnimesByPage(params: params);
    // expect
    expect(result.isRight(), true);
  });

  test('Deve retornar uma left quando houver falha no datasource', () async {
    // arrage
    final params = AnimePostDTO(page: 1);
    when(() => datasource.getAnimesByPage(params: params)).thenThrow(AnimeException('message'));
    // act
    final result = await repository.getAnimesByPage(params: params);
    // expect
    expect(result.isLeft(), true);
  });
}
