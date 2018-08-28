#include <stdio.h>
#include <unistd.h>

int main(void)
{
  printf("From master : HELLO\n");
  fflush(stdout);
  sleep(12);
/* fflush(stdout); */ /* not needed as buffers are implicitly flushed on the program's end */

  return 0;
}
