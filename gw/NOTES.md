
```
│ Error: compute.VirtualMachinesClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="ResourcePurchaseValidationFailed" Message="User failed validation to purchase resources. Error message: 'You have not accepted the legal terms on this subscription: 'f4ad5e85-ec75-4321-8854-ed7eb611f61d' for this plan. Before the subscription can be used, you need to accept the legal terms of the image. To read and accept legal terms, use the Azure CLI commands described at https://go.microsoft.com/fwlink/?linkid=2110637 or the PowerShell commands available at https://go.microsoft.com/fwlink/?linkid=862451. Alternatively, deploying via the Azure portal provides a UI experience for reading and accepting the legal terms. Offer details: publisher='checkpoint' offer = 'check-point-cg-r82', sku = 'sg-byol', Correlation Id: '0d444235-04bb-c9c2-6046-225734e4a25f'.'"
│ 
```

"ChatGPT, give me az cli command to accept terms as reported in this error message"

```shell
az vm image terms accept --publisher checkpoint --offer check-point-cg-r82 --plan sg-byol

```