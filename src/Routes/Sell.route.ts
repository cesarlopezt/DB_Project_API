import { Request, Response, Router } from 'express';
import { authenticateToken } from '../utils/auth.utils';
import pool from '../utils/dbConnection.utils';
import { InvoiceSchema, paymentmethodSchema, SellDetailSchema } from '../Schemas/Sell';

const router: Router = require('express').Router();
router.use(authenticateToken);

router.get('', async (req: Request, res: Response): Promise<Response> => {

    let currentSell = await pool.query(""); // Function to get the sell a user is using at the moment
    let items = pool.query("", [currentSell.rows[0].idsell]); // SP to get all Items to the sell list or cart

    return res.status(200).send(req.body.user);
});

router.post('', async (req: Request, res: Response): Promise<Response> => {
    const validation = SellDetailSchema.validate(req.body);
    if (validation.error) return res.status(400).send(validation.error.message);

    let currentSell = await pool.query(""); // Function to get the sell a user is using at the moment
    let items = await pool.query("CALL create_selldetails($1, $2, $3)", [currentSell.rows[0].idsell]); // SP to create sell detail AKA to add Item to the sell list or cart
    // We cant add items already added
    return res.status(200).send({ items });
});

router.patch('/:itemid', async (req: Request, res: Response): Promise<Response> => {
    let items = await pool.query("");// SP to modify amount of an Item on the cart

    return res.status(200).send({ items });
});

router.post('/pay', async (req: Request, res: Response): Promise<Response> => {
    const validation = InvoiceSchema.validate(req.body);
    if (validation.error) return res.status(400).send(validation.error.message);

    let currentSell = await pool.query(""); // Function to get the sell a user is using at the moment
    let invoice = await pool.query("CALL create_invoice($1, $2, $3)", [currentSell.rows[0].idsell, req.body.paymentmethod, true]); // Function to create invoice with the sell currently in use
    let newSell = await pool.query("CALL create_sell($1)", [parseInt(<string>req.body.user.idcustomer)]) // Function to create new sell after the previous one is paid


    // need to update the quantity of the items sold
    return res.status(200).send('Invoice and new Sell created successfully');
});


router.get('/paymentmethod', async (req: Request, res: Response): Promise<Response> => {
    let results = await pool.query("") // Function get all paymnent methods

    return res.status(200).send('Payment Method created successfully');
});

router.post('/paymentmethod', async (req: Request, res: Response): Promise<Response> => {
    const validation = paymentmethodSchema.validate(req.body);
    if (validation.error) return res.status(400).send(validation.error.message);
    let newPaymentMethod = await pool.query("CALL create_paymentmethod($1)", [validation.value.name]) // SP to create new payment method

    return res.status(200).send('Payment Method created successfully');
});

export default router;