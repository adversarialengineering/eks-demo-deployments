package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"time"

	"github.com/gorilla/mux"
)

const (
	defaultSrvAddr    = "0.0.0.0:8000"
	defaultSrvTimeout = "15"
)

var (
	srvAddr    = os.Getenv("SRV_ADDR")
	srvTimeout = os.Getenv("SRV_TIMEOUT")
)

func init() {
	if srvAddr == "" {
		srvAddr = defaultSrvAddr
	}
	if srvTimeout == "" {
		srvTimeout = defaultSrvTimeout
	}
}

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/", RootHandler)
	router.HandleFunc("/cmd", CmdHandler).Methods("POST")

	srv := &http.Server{
		Handler: router,
		Addr:    srvAddr,
		// Good practice: enforce timeouts for servers you create!
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
		IdleTimeout:  time.Second * 60,
	}

	// Run our server in a goroutine so that it doesn't block.
	go func() {
		if err := srv.ListenAndServe(); err != nil {
			log.Println(err)
		}
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c

	waitSeconds, err := strconv.Atoi(srvTimeout)
	if err != nil {
		log.Fatal("invalid timeout")
	}
	wait := time.Second * time.Duration(waitSeconds)
	ctx, cancel := context.WithTimeout(context.Background(), wait)
	defer cancel()
	srv.Shutdown(ctx)
	log.Println("shutting down")
}

func RootHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Welcome to os command injection app\n")
}

type CommandRequest struct {
	Command string `json:"command"`
}

type CommandResponse struct {
	Result string `json:"result"`
}

func CmdHandler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "", http.StatusBadRequest)
		return
	}
	var cmd CommandRequest
	if err := json.Unmarshal(body, &cmd); err != nil {
		http.Error(w, "", http.StatusBadRequest)
		return
	}

	out, err := exec.Command(cmd.Command).Output()
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	cmdRes := CommandResponse{
		Result: string(out),
	}

	res, err := json.Marshal(cmdRes)
	if err != nil {
		http.Error(w, "", http.StatusBadRequest)
		return
	}

	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "%s\n", res)
}
