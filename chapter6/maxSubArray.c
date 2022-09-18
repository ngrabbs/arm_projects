#include <stdio.h>
#include <limits.h>

int maxSubArray(int nums[], int numsSize) {
  int max_ending_here = 0, max_so_far = INT_MIN;

  for (int i = 0; i < numsSize; i++) {
    if(nums[i] <= max_ending_here + nums[i]) {
      max_ending_here += nums[i];
    } else {
      max_ending_here = nums[i];
    }

    if (max_ending_here > max_so_far) {
      max_so_far = max_ending_here;
    }


  }
  return max_so_far;
};


int main(main)
{
  int nums[] = {-2,1,-3,4,-1,2,1,-5,4};
  int n = sizeof(nums)/sizeof(nums[0]);
  printf("maxSubArray: %d\r\n", maxSubArray(nums, n));
  return 0;
};