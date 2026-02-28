import 'package:cloudinary/cloudinary.dart';
import 'package:dio/dio.dart';
import 'package:serverpod/serverpod.dart';

class CloudinaryService {
  late final Cloudinary client;
  final String cloudName;

  CloudinaryService(Session session)
    : cloudName = session.passwords['cloudinaryCloudName'] ?? 'demo' {
    final apiKey = session.passwords['cloudinaryApiKey'];
    final apiSecret = session.passwords['cloudinaryApiSecret'];

    client = Cloudinary.signedConfig(
      apiKey: apiKey ?? '',
      apiSecret: apiSecret ?? '',
      cloudName: cloudName,
    );
  }

  /// Uploads an image from a URL or file path.
  Future<CloudinaryResponse?> uploadImage(
    Session session,
    String fileSource, {
    String? folder,
    String? publicId,
  }) async {
    try {
      // If it's a web URL, download it first to bypass potential blocks
      if (fileSource.startsWith('http')) {
        final dio = Dio();
        final response = await dio.get<List<int>>(
          fileSource,
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
              'Referer': 'https://m.khmer24.com/',
            },
          ),
        );

        if (response.data != null) {
          return await client.upload(
            fileBytes: response.data,
            folder: folder,
            publicId: publicId,
            resourceType: CloudinaryResourceType.image,
          );
        }
      }

      // Fallback for local files or direct upload
      return await client.upload(
        file: fileSource,
        folder: folder,
        publicId: publicId,
        resourceType: CloudinaryResourceType.image,
      );
    } catch (e, stack) {
      session.log(
        'Cloudinary upload error ($fileSource): $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Uploads an image from bytes.
  Future<CloudinaryResponse?> uploadImageBytes(
    Session session,
    List<int> bytes, {
    String? folder,
    String? publicId,
  }) async {
    try {
      return await client.upload(
        fileBytes: bytes,
        folder: folder,
        publicId: publicId,
        resourceType: CloudinaryResourceType.image,
      );
    } catch (e, stack) {
      session.log(
        'Cloudinary upload bytes error: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Generates a transformed URL for an image.
  String getImageUrl(String publicId, {int? width, int? height}) {
    // If we don't have a real cloud name yet, return a placeholder
    if (cloudName == 'your-cloud-name' || cloudName == 'demo') {
      return 'https://res.cloudinary.com/demo/image/upload/v1/sample.jpg';
    }

    // Basic URL generation
    final transformations = <String>[];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('c_fill');

    final transformString = transformations.isNotEmpty
        ? transformations.join(',') + '/'
        : '';
    return 'https://res.cloudinary.com/$cloudName/image/upload/${transformString}v1/$publicId';
  }
}
