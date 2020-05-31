#include <stdlib.h>
#include <stdio.h>

#include <mruby.h>
#include <mruby/compile.h>
#include <mruby/string.h>
#include <mruby/numeric.h>

static int
load_rb_file(mrb_state *mrb, mrb_value filepath)
{
  FILE *fp;
  const char *fpath = mrb_string_value_cstr(mrb, &filepath);
  mrbc_context *mrbc_ctx;
  int ai = mrb_gc_arena_save(mrb);

  fp = fopen((const char*)fpath, "r");
  if (fp == NULL)
    return 1;

  mrbc_ctx = mrbc_context_new(mrb);

  mrbc_filename(mrb, mrbc_ctx, fpath);
  mrb_load_file_cxt(mrb, fp, mrbc_ctx);
  fclose(fp);

  mrb_gc_arena_restore(mrb, ai);
  mrbc_context_free(mrb, mrbc_ctx);

  return 0;
}

mrb_value
mrb_f_load(mrb_state *mrb, mrb_value self)
{
  mrb_value filename;

  mrb_get_args(mrb, "o", &filename);
  if (mrb_type(filename) != MRB_TT_STRING) {
    mrb_raisef(mrb, E_TYPE_ERROR, "can't convert %S into String", filename);
    return mrb_nil_value();
  }

  return mrb_int_value(mrb, load_rb_file(mrb, filename));
}

void
mrb_mruby_require_gem_init(mrb_state* mrb)
{
  struct RClass *kernel;
  kernel = mrb->kernel_module;

  mrb_define_method(mrb, kernel, "__load__", mrb_f_load, MRB_ARGS_REQ(1));
}

void
mrb_mruby_require_gem_final(mrb_state* mrb)
{
}
