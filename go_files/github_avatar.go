package main

/*
#include <stdlib.h>
#include <string.h>
*/
import "C"
import (
	"fmt"
	"io"
	"net/http"
	"unsafe"
)

//export GetGithubAvatar
func GetGithubAvatar(username *C.char, length *C.int) unsafe.Pointer {
	goUsername := C.GoString(username)
	url := fmt.Sprintf("https://github.com/%s.png", goUsername)

	resp, err := http.Get(url)
	if err != nil {
		*length = 0
		return unsafe.Pointer(nil)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		*length = 0
		return unsafe.Pointer(nil)
	}

	imageBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		*length = 0
		return unsafe.Pointer(nil)
	}

	*length = C.int(len(imageBytes))
	// Allocate C memory and copy the bytes
	result := C.malloc(C.size_t(len(imageBytes)))
	C.memcpy(result, unsafe.Pointer(&imageBytes[0]), C.size_t(len(imageBytes)))
	return result
}

func main() {}