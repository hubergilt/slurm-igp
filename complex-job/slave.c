#include <stdio.h>
#include <unistd.h>

int main(void)
{
  printf("From slave : HELLO\n");
  sleep(10);
/* fflush(stdout); */ /* not needed as buffers are implicitly flushed on the program's end */

  return 0;
}
