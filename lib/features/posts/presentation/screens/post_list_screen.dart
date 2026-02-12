import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_production_sample/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_production_sample/features/posts/presentation/providers/post_providers.dart';

class PostListScreen extends ConsumerStatefulWidget {
  const PostListScreen({super.key});

  @override
  ConsumerState<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends ConsumerState<PostListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postListControllerProvider.notifier).fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Posts'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(postListControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
          Consumer(
            builder: (context, ref, _) {
              return IconButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
      body: state.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(postListControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        success: (posts, hasReachedMax) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(postListControllerProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: hasReachedMax ? posts.length : posts.length + 1,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index >= posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final post = posts[index];
                return ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/post/${post.id}', extra: post),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
