#include <stdio.h>
#include <unistd.h>

int main(void)
{
  printf("From prog2 : HELLO");
  fflush(stdout);
  sleep(12);
/* fflush(stdout); */ /* not needed as buffers are implicitly flushed on the program's end */

  return 0;
}
