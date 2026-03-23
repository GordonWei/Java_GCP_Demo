package com.ikala.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/checkout")
public class CheckoutController {
    private static final List<byte[]> leakyList = new ArrayList<>();

    @GetMapping("/fast")
    public String fastCheckout() {
        return "Checkout completed seamlessly in 50ms!";
    }

    @GetMapping("/slow")
    public String slowCheckout() throws InterruptedException {
        Thread.sleep(3000); 
        return "Checkout delayed! Took 3000ms to response.";
    }

    @GetMapping("/leak")
    public String memoryLeak() {
        byte[] junk = new byte[10 * 1024 * 1024];
        leakyList.add(junk);
        return "Leaked 10MB. Total leaked items in heap: " + leakyList.size();
    }
}
