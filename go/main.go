package main

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"
)

func main() {
	var name string

	rootCmd := &cobra.Command{
		Use:   "hello",
		Short: "Says hello",
		Long:  ``,
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("Hello %s\n", name)
		},
	}
	rootCmd.PersistentFlags().StringVar(&name, "name", "World", "Name")

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
