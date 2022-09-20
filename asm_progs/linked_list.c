#include <stdlib.h> #include <string.h>
typedef struct userL
{
  char uname[80];
  char passwd[80];
  int uid;
  int admin;
  struct userL *next;
} userL;
userL *users = NULL;
// user name
// password
// user identification number
// 1 indicates administrator privileges
void insertUser(char *uname, char *passwd, int uid, int admin)
{
  userL *newUser;
  newUser = malloc(sizeof(userL));
  strcpy(newUser->uname, uname);
  strcpy(newUser->passwd, passwd);
  newUser->uid = uid;
  newUser->admin = admin;
  newUser->next = users;
  // create space for new user
  // copy values into user fields
  // insert at start of linked list
  users = newUser;
}
void deleteUser(int uid)
{
  userL *cur = users;
  userL *prev = NULL;
  // delete first user with given uid
  while (cur != NULL)
  {
    if (cur->uid = = uid)
    { // found the user to delete
      if (prev = = NULL)
        users = cur->next;
      else
        prev->next = cur->next;
      free(cur);
      return; // done
    }
    prev = cur;
    cur = cur->next;
  }
}
// otherwise, keep scanning through list
userL *findUser(int uid)
{
  userL *cur = users;
  while (cur != NULL)
  {
    if (cur->uid = = uid)
      return cur;
    else
      cur = cur->next;
  }
  return NULL;
}
int numUsers(void)
{
  userL *cur = users;
  int count = 0;
  while (cur != NULL)
  {
    count++;
    cur = cur->next;
  }
  return count;
}