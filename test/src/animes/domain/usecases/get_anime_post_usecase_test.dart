import 'package:dartz/dartz.dart';
import 'package:flutter_parquinho/src/animes/domain/dtos/anime_post_dto.dart';
import 'package:flutter_parquinho/src/animes/domain/entities/anime_post_entity.dart';
import 'package:flutter_parquinho/src/animes/domain/errors/errors.dart';
import 'package:flutter_parquinho/src/animes/domain/repositories/anime_repository.dart';
import 'package:flutter_parquinho/src/animes/domain/usecases/get_anime_post_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AnimeRepositoryMock extends Mock implements AnimeRepository {}

final throwAnimeException = throwsA(isA<AnimeException>());

void main() {
  late GetAnimePostUsecase usecase;
  late AnimeRepository repository;

  setUp(() {
    repository = AnimeRepositoryMock();
    usecase = GetAnimePostUsecaseImpl(repository);
  });

  test('Deve retornar uma lista de animes', () async {
    //arrange
    final params = AnimePostDTO(page: 1);
    final anime = AnimePostEntity(title: 'title', url: 'url');
    when(() => repository.getAnimesByPage(params: params)).thenAnswer((_) async => Right([anime]));
    //act
    final result = await usecase(params: params);
    //expect
    expect(result.isRight(), true);
    expect(result.getOrElse(() => []).length, 1);
  });

  test('Deve lançar uma exception quando passar pagina com valor 0', () async {
    //arrange
    final params = AnimePostDTO(page: 0);
    //act
    final result = await usecase(params: params);
    //expect
    expect(result.isLeft(), true);
  });

  test('Deve lançar uma exception quando passar offset com valor 0', () async {
    //arrange
    final params = AnimePostDTO(page: 1, offset: 0);
    //act
    final result = await usecase(params: params);
    //expect
    expect(result.isLeft(), true);
  });

  test('Deve lançar uma exception quando o repository falhar', () async {
    //arrange
    final params = AnimePostDTO(page: 1);
    when(() => repository.getAnimesByPage(params: params)).thenAnswer(
      (_) async => Left(AnimeException('message')),
    );
    //act
    final result = await usecase(params: params);
    //expect
    expect(result.isLeft(), true);
  });
}
