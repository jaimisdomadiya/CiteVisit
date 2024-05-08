part of 'widgets.dart';

class ImageView extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double width;
  final double? radius;
  final Widget? errorWidget;

  const ImageView({
    Key? key,
    required this.imageUrl,
    this.height,
    required this.width,
    this.radius,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            height: height,
            width: width,
            imageBuilder: (context, image) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(
                    radius ?? BorderRadiusValues.radiusSmall.r,
                  ),
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            },
            memCacheHeight: 150,
            memCacheWidth: 200,
            placeholder: (context, url) => _buildPlaceHolder(),
            errorWidget: (context, url, error) =>
                errorWidget ?? _buildErrorWidget(),
          )
        : _buildPlaceHolder();
  }

  Widget _buildPlaceHolder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          radius ?? BorderRadiusValues.radiusSmall.r,
        ),
      ),
    ).toShimmer();
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.greyBackgroundColor,
        borderRadius: BorderRadius.circular(
          radius ?? BorderRadiusValues.radiusSmall.r,
        ),
      ),
      child: SvgPicture.asset(
        AppAssets.imagePlaceholder,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double? height;
  final double width;
  final double? radius;

  const ProfileView({
    Key? key,
    required this.imageUrl,
    this.name,
    this.height,
    required this.width,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (imageUrl?.isNotEmpty ?? false)
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            height: height,
            width: width,
            imageBuilder: (context, image) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(
                    radius ?? BorderRadiusValues.radiusSmall.r,
                  ),
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            },
            memCacheHeight: 150,
            memCacheWidth: 200,
            placeholder: (context, url) => _buildPlaceHolder(),
            errorWidget: (context, url, error) => _buildErrorWidget(),
          )
        : _buildNameHolder();
  }

  Widget _buildPlaceHolder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          radius ?? BorderRadiusValues.radiusSmall.r,
        ),
      ),
    ).toShimmer();
  }

  Widget _buildNameHolder() {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        borderRadius: BorderRadius.circular(
          radius ?? BorderRadiusValues.radiusSmall.r,
        ),
      ),
      child: Text(
        name?[0].toUpperCase() ?? '',
        style: TextStyle(
            fontSize: Sizes.s16.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.greyBackgroundColor,
        borderRadius: BorderRadius.circular(
          radius ?? BorderRadiusValues.radiusSmall.r,
        ),
      ),
      child: SvgPicture.asset(
        AppAssets.imagePlaceholder,
        fit: BoxFit.cover,
      ),
    );
  }
}
