#include <stdio.h>
#include <unistd.h>

int main(void)
{
  sleep(10);
  printf("prog3 : HELLO\n");
/* fflush(stdout); */ /* not needed as buffers are implicitly flushed on the program's end */

  return 0;
}
