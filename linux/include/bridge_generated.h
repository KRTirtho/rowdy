#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_init_player(int64_t port_);

void wire_play(int64_t port_, struct wire_uint_8_list *path);

void wire_pause(int64_t port_);

void wire_shuffle(int64_t port_);

void wire_set_volume(int64_t port_, int32_t volume);

void wire_set_speed(int64_t port_, float speed);

void wire_get_volume(int64_t port_);

void wire_get_speed(int64_t port_);

void wire_toggle_playback(int64_t port_);

void wire_resume(int64_t port_);

void wire_duration(int64_t port_);

void wire_elapsed(int64_t port_);

void wire_progress_stream(int64_t port_);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_init_player);
    dummy_var ^= ((int64_t) (void*) wire_play);
    dummy_var ^= ((int64_t) (void*) wire_pause);
    dummy_var ^= ((int64_t) (void*) wire_shuffle);
    dummy_var ^= ((int64_t) (void*) wire_set_volume);
    dummy_var ^= ((int64_t) (void*) wire_set_speed);
    dummy_var ^= ((int64_t) (void*) wire_get_volume);
    dummy_var ^= ((int64_t) (void*) wire_get_speed);
    dummy_var ^= ((int64_t) (void*) wire_toggle_playback);
    dummy_var ^= ((int64_t) (void*) wire_resume);
    dummy_var ^= ((int64_t) (void*) wire_duration);
    dummy_var ^= ((int64_t) (void*) wire_elapsed);
    dummy_var ^= ((int64_t) (void*) wire_progress_stream);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}