import 'package:fluent_ui/fluent_ui.dart';

class GridGallery extends StatelessWidget {
  final List<String> imageUrls;
  final void Function(String)? onImageTap;
  final void Function()? onAddImage;

  const GridGallery({
    super.key,
    required this.imageUrls,
    this.onImageTap,
    this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Photos (${imageUrls.length})',
                style: FluentTheme.of(context).typography.bodyStrong,
              ),
            ),
            if (onAddImage != null)
              IconButton(
                icon: const Icon(FluentIcons.add),
                onPressed: onAddImage,
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        if (imageUrls.isEmpty)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.dashed,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FluentIcons.photo2, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'No photos added',
                  style: FluentTheme.of(context).typography.caption?.copyWith(
                    color: Colors.grey[100],
                  ),
                ),
                if (onAddImage != null) ...[
                  const SizedBox(height: 8),
                  Button(
                    child: const Text('Add Photos'),
                    onPressed: onAddImage,
                  ),
                ],
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: imageUrls.length + (onAddImage != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (onAddImage != null && index == imageUrls.length) {
                // Add button as last item
                return _AddPhotoTile(onTap: onAddImage!);
              }
              
              final imageUrl = imageUrls[index];
              return _PhotoTile(
                imageUrl: imageUrl,
                onTap: () => onImageTap?.call(imageUrl),
              );
            },
          ),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const _PhotoTile({
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[60]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[20],
                child: const Icon(
                  FluentIcons.photo2,
                  size: 32,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.dashed,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.add, size: 32, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}