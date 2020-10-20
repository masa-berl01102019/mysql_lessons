

<?php $__env->startSection('title','Edit Post'); ?>

<?php $__env->startSection('content'); ?>
 <h1>
   <a href="<?php echo e(url('/')); ?>" class="header-menu">Back</a>
   Edit post
 </h1>
 <form action="<?php echo e(url('/posts',$post->id)); ?>" method="post" >
   <?php echo e(csrf_field()); ?>

   <?php echo e(method_field('patch')); ?>

   
   <p>
     <input type="text" name="title" placeholder="enter title" value="<?php echo e(old('title',$post->title)); ?>">
     
     <?php if($errors->has('title')): ?>
     <span class="error"><?php echo e($errors->first('title')); ?></span>
     <?php endif; ?>
   </p>
   <p>
     <textarea name="body" placeholder="enter body" ><?php echo e(old('body',$post->body)); ?></textarea>
     <?php if($errors->has('body')): ?>
     <span class="error"><?php echo e($errors->first('body')); ?></span>
     <?php endif; ?>
   </p>
   <p>
     <input type="submit" value="Update">
   </p>
 </form>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.default', \Illuminate\Support\Arr::except(get_defined_vars(), array('__data', '__path')))->render(); ?>