#include <stddef.h>
#include "ex10_ll_cycle.h"

int ll_has_cycle(node *head) {
    if (head == NULL) {
        return 0;
    }

    node *fast = head;
    node *slow = head;
    while (fast != NULL && fast->next != NULL) {
        fast = fast->next->next;
        slow = slow->next;

        if (fast == slow) {
            return 1;
        }
    }

    return 0;
}
