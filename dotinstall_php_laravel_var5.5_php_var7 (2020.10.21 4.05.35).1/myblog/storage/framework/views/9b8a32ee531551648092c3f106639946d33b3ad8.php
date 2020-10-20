


<?php $__env->startSection('title'); ?>
  Blog Posts
<?php $__env->stopSection(); ?>


 <?php $__env->startSection('content'); ?>
   <h1>
     <a href="<?php echo e(url('/posts/create')); ?>" class="header-menu">New Post</a>
     Blog Posts
   </h1>
   <ul>
     
     

     <?php $__empty_1 = true; $__currentLoopData = $posts; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $post): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
       
       <li>
         <a href="<?php echo e(action('PostsController@show', $post)); ?>"><?php echo e($post->title); ?></a>
         <a href="<?php echo e(action('PostsController@edit', $post)); ?>" class="edit">[Edit]</a>
         <a href="#" class="del" data-id="<?php echo e($post->id); ?>">[×]</a>
         
         <form method="post" action="<?php echo e(url('/posts',$post->id)); ?>" id="form_<?php echo e($post->id); ?>">
           <?php echo e(csrf_field()); ?>

           <?php echo e(method_field('delete')); ?>

         </form>
       </li>
     <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
       <li>No posts yet</li>
     <?php endif; ?>
       
   </ul>
   <script src="/js/main.js"></script>
 <?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.default', \Illuminate\Support\Arr::except(get_defined_vars(), array('__data', '__path')))->render(); ?>