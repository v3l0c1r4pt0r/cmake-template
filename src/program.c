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
#include <stdio.h>
#include <limits.h>
#include <getopt.h>

#include "module.h"

#define LONG_OPTION (( CHAR_MAX + 1 ))

int internal(int a, int b)
{
  return a * b;
}

int main(int argc, char **argv)
{
  int c;
  int digit_optind = 0;

  int one = 10;
  int two = 2;
  int result = internal(one, two);
  result += external(result);
  printf("%d\n", result);

  while (1) {
    int this_option_optind = optind ? optind : 1;
    int option_index = 0;
    static struct option long_options[] = {
      /* {name, has_arg, flag, val} */
      {"option", required_argument, 0, 'o' },
      {"switch", no_argument, 0, 's' },
      {"dual", optional_argument, 0, 'd' },
      {"long", no_argument, 0, LONG_OPTION },
      {0, 0, 0, 0 }
    };

    c = getopt_long(argc, argv, "o:sd::",
        long_options, &option_index);
    if (c == -1)
      break;

    switch (c) {
      case 0:
        /* for default long options
         * (option->flag==0 -> 4th element of struct option) */
        printf("option %s", long_options[option_index].name);
        if (optarg)
          printf(" with arg %s", optarg);
        printf("\n");
        break;

      case '0':
      case '1':
      case '2':
        if (digit_optind != 0 && digit_optind != this_option_optind)
          printf("digits occur in two different argv-elements.\n");
        digit_optind = this_option_optind;
        printf("option %c\n", c);
        break;

      case 'o':
        /* --option=VAL */
        printf("option with value '%s'\n", optarg);
        break;

      case 's':
        /* --switch */
        printf("switch\n");
        break;

      case 'd':
        /* --dual[=VAL] */
        if (optarg == NULL)
        {
        printf("dual without value\n");
        }
        else
        {
        printf("dual with value '%s'\n", optarg);
        }
        break;

      case LONG_OPTION:
        /* --long */
        printf("long option\n");
        break;

      case '?':
        /* -* not in optstring */
        break;

      default:
        /* optstrings not handled (mistakes?) */
        printf("?? getopt returned character code 0%o ??\n", c);
    }
  }

  /* positional arguments */
  if (optind < argc) {
      printf("non-option ARGV-elements: ");
      while (optind < argc)
    printf("%s ", argv[optind++]);
      printf("\n");
  }

  return 0;
}
