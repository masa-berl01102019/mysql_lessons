

<?php $__env->startSection('title',$post->title); ?>

<?php $__env->startSection('content'); ?>
 <h1>
   <a href="<?php echo e(url('/')); ?>" class="header-menu">Back</a>
   <?php echo e($post->title); ?>

 </h1>
 <p><?php echo nl2br(e($post->body)); ?></p>
 

<h2>Comments</h2>
<ul>
  <?php $__empty_1 = true; $__currentLoopData = $post->comments; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $comment): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
    <li>
      <?php echo e($comment->body); ?>

      <a href="#" class="del" data-id="<?php echo e($comment->id); ?>">[×]</a>
      <form method="post" action="<?php echo e(action('CommentsController@destroy',[$post,$comment])); ?>" id="form_<?php echo e($comment->id); ?>">
      
        <?php echo e(csrf_field()); ?>

        <?php echo e(method_field('delete')); ?>

      </form>
    </li>

  <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
    <li>No comments yet</li>
  <?php endif; ?>
</ul>

<form action="<?php echo e(action('CommentsController@store',$post)); ?>" method="post" >
  <?php echo e(csrf_field()); ?>

  <p>
    <input type="text" name="body" placeholder="enter comment" value="<?php echo e(old('body')); ?>">
    <?php if($errors->has('body')): ?>
    <span class="error"><?php echo e($errors->first('body')); ?></span>
    <?php endif; ?>
  </p>
  <p>
    <input type="submit" value="Add Comment">
  </p>
</form>
<script src="/js/main.js"></script>

<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.default', \Illuminate\Support\Arr::except(get_defined_vars(), array('__data', '__path')))->render(); ?>