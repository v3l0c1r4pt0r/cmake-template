/*
 * MIT License
 *
 * Copyright (c) 2018 Kamil Lorenc
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#include <stdarg.h>
#include <stddef.h>
#include <limits.h>
#include <setjmp.h>
#include <cmocka.h>

#define main __real_main
#include "program.c"
#undef main

typedef struct {int a; int b; int expected;} vector_t;

const vector_t vectors[] = {
  {0,1,0},
  {1,0,0},
  {1,1,1},
  {2,3,6},
};

int __wrap_printf (const char *format, ...)
{
  int param1;

  /* extract result from vargs ('printf("%d\n", result)') */
  va_list args;
  va_start(args, format);
  param1 = va_arg(args, int);
  va_end(args);

  /* ensure that parameters match expecteds in expect_*() calls  */
  check_expected_ptr(format);
  check_expected(param1);

  /* get mocked return value from will_return() call */
  return mock();
}

static void test_internal(void **state)
{
    int actual;
    int i;

    for (i = 0; i < sizeof(vectors)/sizeof(vector_t); i++)
    {
      /* get i-th inputs and expected values as vector */
      const vector_t *vector = &vectors[i];

      /* call function under test */
      actual = internal(vector->a, vector->b);

      /* assert result */
      assert_int_equal(vector->expected, actual);
    }
}

static void test_main(void **state)
{
  int expected = 0;
  int actual;

  /* expect parameters to printf call */
  expect_string(__wrap_printf, format, "%d\n");
  expect_value(__wrap_printf, param1, 60);

  /* printf should return 3 */
  will_return(__wrap_printf, 3);

  /* call __real_main as this is main() from program.c */
  actual = __real_main(0, NULL);

  /* assert that main return success */
  assert_int_equal(expected, actual);
}

int main()
{
  const struct CMUnitTest tests[] = {
    cmocka_unit_test(test_internal),
    cmocka_unit_test(test_main),
  };

  return cmocka_run_group_tests(tests, NULL, NULL);
}
